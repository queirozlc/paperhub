import type { UserType } from '$pages/Users/types'
import { Extension } from '@tiptap/core'
import * as Y from 'yjs'
import { YChange } from './ychange'

interface UpdateEvent {
  update: Uint8Array<ArrayBufferLike>
}

interface SnapshotDiffOptions {
  doc: Y.Doc | null
  user: UserType

  onUpdate?: (data: UpdateEvent) => void
}

export interface VersionParams {
  message: string
  description?: string

  date: number

  clientID: number

  author: {
    id: number
    name: string
    email: string
    avatar?: string
  }
}

export interface VersionSnapshot extends VersionParams {
  snapshot: Uint8Array<ArrayBufferLike>
}

declare module '@tiptap/core' {
  interface Commands<ReturnType> {
    snapshotDiff: {
      addVersion: (version: VersionParams) => ReturnType
    }
  }
}

export const SnapshotDiff = Extension.create<SnapshotDiffOptions>({
  name: 'snapshot-diff',
  addOptions() {
    return {
      doc: new Y.Doc(),
      user: null,
      onUpdate: () => {},
    }
  },

  addExtensions() {
    return [YChange]
  },

  addCommands() {
    return {
      addVersion: (version: VersionParams) => () => {
        const versions = this.options.doc.getArray('versions')

        const prevVersion: {
          snapshot: Uint8Array<ArrayBufferLike>
          clientID: number
        } | null =
          versions.length === 0
            ? null
            : (versions.get(versions.length - 1) as {
                snapshot: Uint8Array<ArrayBufferLike>
                clientID: number
              })

        const prevSnapshot =
          prevVersion === null
            ? Y.emptySnapshot
            : Y.decodeSnapshot(prevVersion.snapshot)

        const snapshot = Y.snapshot(this.options.doc)

        if (prevVersion !== null) {
          prevSnapshot.sv.set(
            prevVersion.clientID,
            prevSnapshot.sv.get(prevVersion.clientID) + 1
          )
        }

        if (!Y.equalSnapshots(prevSnapshot, snapshot)) {
          versions.push([
            {
              ...version,
              snapshot: Y.encodeSnapshot(snapshot),
            },
          ])
          console.log({ update: Y.encodeStateAsUpdate(this.options.doc) })
          this.options.onUpdate?.({
            update: Y.encodeStateAsUpdate(this.options.doc),
          })
        }

        return true
      },
    }
  },
})
