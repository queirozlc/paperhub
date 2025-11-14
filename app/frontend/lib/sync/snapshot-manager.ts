import { router } from '@inertiajs/svelte'
import { fromUint8Array, toUint8Array } from 'js-base64'
import * as Y from 'yjs'

export interface SnapshotMetadata {
  message: string
  description?: string
  workspaceId: number
}

export interface Snapshot {
  id: number
  message: string
  description?: string
  snapshot_data: string // base64
  client_id: number
  snapshot_date: string
  created_at: string
  author: {
    id: number
    name: string
    email: string
    avatar?: string
  }
}

/**
 * Manages Yjs snapshots for document versioning
 * Based on: https://github.com/yjs/yjs-demos/blob/main/prosemirror-versions/prosemirror-versions.js
 */
export class SnapshotManager {
  private doc: Y.Doc
  private documentId: string

  constructor(doc: Y.Doc, documentId: string) {
    this.doc = doc
    this.documentId = documentId
  }

  /**
   * Create a new snapshot
   * Captures the current state of the Y.Doc and sends it to the server
   * Based on: https://github.com/yjs/yjs-demos/blob/main/prosemirror-versions/prosemirror-versions.js
   */
  async createSnapshot(metadata: SnapshotMetadata): Promise<void> {
    // Create Yjs snapshot
    const snapshot = Y.snapshot(this.doc)
    const encodedSnapshot = Y.encodeSnapshot(snapshot)

    // Convert to base64 for transport
    const snapshotBase64 = fromUint8Array(encodedSnapshot)

    return new Promise((resolve, reject) => {
      router.post(
        `/documents/${this.documentId}/workspaces/${metadata.workspaceId}/snapshots`,
        {
          snapshot: {
            message: metadata.message,
            description: metadata.description,
            snapshot_data: snapshotBase64,
            client_id: this.doc.clientID,
            snapshot_date: new Date().toISOString(),
          },
        },
        {
          preserveState: false,
          preserveScroll: false,
          onSuccess: () => {
            resolve()
          },
          onError: (errors) => {
            console.error('Failed to create snapshot:', errors)
            reject(errors)
          },
        }
      )
    })
  }

  /**
   * Decode a snapshot from base64 to Y.Snapshot
   */
  decodeSnapshot(snapshotBase64: string): Y.Snapshot {
    const bytes = toUint8Array(snapshotBase64)
    return Y.decodeSnapshot(bytes)
  }

  /**
   * Compare two snapshots and check if they're equal
   */
  areSnapshotsEqual(snapshot1Base64: string, snapshot2Base64: string): boolean {
    const snap1 = this.decodeSnapshot(snapshot1Base64)
    const snap2 = this.decodeSnapshot(snapshot2Base64)
    return Y.equalSnapshots(snap1, snap2)
  }
}
