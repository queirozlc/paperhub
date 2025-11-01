import { router, type Errors } from '@inertiajs/core'
import { fromUint8Array } from 'js-base64'
import { IndexeddbPersistence } from 'y-indexeddb'
import * as Y from 'yjs'


export interface SyncerOptions {
  documentId: string
  doc: Y.Doc
  debounceMs?: number
  onSyncStart?: () => void
  onSyncSuccess?: (bytesSync: number) => void
  onSyncError?: (error: Errors) => void
}

export interface SyncResponse {
  success: boolean
  size: number
}

/**
 * Handles efficient synchronization of Yjs documents to the server
 *
 * Features:
 * - Batches multiple updates into a single HTTP request
 * - Debounces sync requests to reduce server load
 * - Handles cleanup on component unmount
 * - Ensures updates are saved before page unload
 *
 * Based on: https://github.com/ueberdosis/tiptap/discussions/5677#discussioncomment-12738111
 */
export class YjsDocumentSyncer {
  private documentId: string
  private doc: Y.Doc
  private updateQueue: Uint8Array[] = []
  private debounceTimer: number | null = null
  private persistence: IndexeddbPersistence
  private debounceMs: number
  private isSyncing = false
  private unloadHandler: ((e: BeforeUnloadEvent) => void) | null = null

  // Callbacks
  private onSyncStart?: () => void
  private onSyncSuccess?: (bytesSync: number) => void
  private onSyncError?: (error: Errors) => void

  constructor(options: SyncerOptions) {
    this.documentId = options.documentId
    this.doc = options.doc
    this.debounceMs = options.debounceMs ?? 1000
    this.persistence = new IndexeddbPersistence(this.documentId, this.doc)
    this.onSyncStart = options.onSyncStart
    this.onSyncSuccess = options.onSyncSuccess
    this.onSyncError = options.onSyncError

    this.setupListeners()
  }

  /**
   * Set up Yjs update listener
   */
  private setupListeners(): void {
    this.doc.on('update', this.handleYjsUpdate)

    // Setup beforeunload handler to ensure updates are saved
    if (typeof window !== 'undefined') {
      this.unloadHandler = this.handleBeforeUnload.bind(this)
      window.addEventListener('beforeunload', this.unloadHandler)
    }
  }

  /**
   * Handle Yjs document updates
   */
  private handleYjsUpdate = (update: Uint8Array, origin: unknown): void => {
    // Only sync updates that come from the local editor (not from the server)
    if (origin !== 'server') {
      this.updateQueue.push(update)
      this.debouncedSync()
    }
  }

  /**
   * Debounced sync function - waits for inactivity before syncing
   */
  private debouncedSync(): void {
    if (this.debounceTimer !== null) {
      clearTimeout(this.debounceTimer)
    }

    this.debounceTimer = window.setTimeout(() => {
      this.syncToServer()
      this.debounceTimer = null
    }, this.debounceMs)
  }

  /**
   * Send batched updates to the server
   */
  private async syncToServer(): Promise<void> {
    if (this.updateQueue.length === 0 || this.isSyncing) {
      return
    }

    this.isSyncing = true
    this.onSyncStart?.()

    try {
      // Merge all queued updates into a single update
      const mergedUpdate = Y.mergeUpdates(this.updateQueue)
      Y.applyUpdate(this.doc, mergedUpdate)

      const bytesCount = mergedUpdate.byteLength

      // Clear the queue since we're processing these updates
      this.updateQueue = []

      // Send to server
      router.patch(
        `/documents/${this.documentId}`,
        {
          content: fromUint8Array(Y.encodeStateAsUpdate(this.doc)),
        },
        {
          onSuccess: () => {
            this.onSyncSuccess?.(bytesCount)
          },
          onError: (error) => {
            console.error('[YjsDocumentSyncer] Error syncing to server:', error)
            this.onSyncError?.(error)
          },
        }
      )
    } catch (error) {
      console.error('[YjsDocumentSyncer] Error syncing to server:', error)
    } finally {
      this.isSyncing = false
    }
  }

  /**
   * Force immediate sync (useful before unmount or navigation)
   */
  public async forceSyncNow(): Promise<void> {
    if (this.debounceTimer !== null) {
      clearTimeout(this.debounceTimer)
      this.debounceTimer = null
    }

    await this.syncToServer()
  }

  /**
   * Handle page unload - use keepalive to ensure request completes
   */
  private handleBeforeUnload(): void {
    if (this.updateQueue.length > 0) {
      // Use keepalive flag to ensure the request completes even after page unload
      const mergedUpdate = Y.mergeUpdates(this.updateQueue)
      const base64Update = this.encodeUpdate(mergedUpdate)

      fetch(`/documents/${this.documentId}/sync`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ update: base64Update }),
        keepalive: true,
      }).catch((err) => {
        console.error('[YjsDocumentSyncer] Error in beforeunload sync:', err)
      })

      // Clear queue since we've sent it
      this.updateQueue = []
    }
  }

  /**
   * Encode Uint8Array to base64 string
   */
  private encodeUpdate(update: Uint8Array): string {
    return btoa(String.fromCharCode(...Array.from(update)))
  }

  /**
   * Clean up listeners and timers
   */
  public destroy(): void {
    // Remove Yjs listener
    this.doc.off('update', this.handleYjsUpdate)

    // Clear debounce timer
    if (this.debounceTimer !== null) {
      clearTimeout(this.debounceTimer)
      this.debounceTimer = null
    }

    // Remove beforeunload listener
    if (this.unloadHandler && typeof window !== 'undefined') {
      window.removeEventListener('beforeunload', this.unloadHandler)
      this.unloadHandler = null
    }

    // Sync any remaining updates (fire and forget)
    if (this.updateQueue.length > 0) {
      this.syncToServer().catch((err) => {
        console.error('[YjsDocumentSyncer] Error in final sync:', err)
      })
    }
  }

  /**
   * Get current queue status for debugging
   */
  get status(): {
    queueLength: number
    isSyncing: boolean
    hasPendingSync: boolean
  } {
    return {
      queueLength: this.updateQueue.length,
      isSyncing: this.isSyncing,
      hasPendingSync: this.debounceTimer !== null,
    }
  }
}
