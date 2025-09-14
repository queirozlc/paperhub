import { describe, it, expect } from 'vitest'
import { diffHtml } from './diff'

describe('Diff Utils', () => {
  describe('diffHtml', () => {
    it('marks diffs with <diff> tag', () => {
        expect(diffHtml('<p>Ball</p>', '<p>Cat</p>'))
            .toStrictEqual(['<p><diff>Ball</diff></p>', '<p><diff>Cat</diff></p>'])

        expect(diffHtml('<p>Ball</p>', '<h1>Ball</h1>'))
            .toStrictEqual(['<p>Ball</p>', '<h1>Ball</h1>'])

        expect(diffHtml('<p>Ball</p>', '<h1>Cat</h1>'))
            .toStrictEqual(['<p><diff>Ball</diff></p>', '<h1><diff>Cat</diff></h1>'])
            
        expect(diffHtml('<h1 id="1">Ball</h1>', '<h1 id="2">Cat</h1>'))
            .toStrictEqual(['<h1 id="1"><diff>Ball</diff></h1>', '<h1 id="2"><diff>Cat</diff></h1>'])

        expect(diffHtml('<p>Dog</p>', '<ul><li>Fish</li><li>Ball</li><li>Cat</li></ul>'))
            .toStrictEqual(['<p><diff>Dog</diff></p>', '<ul><li><diff>Fish</diff></li><li><diff>Ball</diff></li><li><diff>Cat</diff></li></ul>'])

        expect(diffHtml('<p>Ball</p>', '<ul><li>Fish</li><li>Ball</li><li>Cat</li></ul>'))
            .toStrictEqual(['<p>Ball</p>', '<ul><li><diff>Fish</diff></li><li>Ball</li><li><diff>Cat</diff></li></ul>'])


        expect(diffHtml('<ul><li>Fish</li><li>Ball</li><li>Cat</li></ul>', '<p>Dog</p>'))
            .toStrictEqual(['<ul><li><diff>Fish</diff></li><li><diff>Ball</diff></li><li><diff>Cat</diff></li></ul>', '<p><diff>Dog</diff></p>'])
    })
  })
})