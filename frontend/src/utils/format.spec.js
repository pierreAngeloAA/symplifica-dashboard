import { describe, expect, it } from 'vitest'
import { benefitsTotal, formatMoney, mapUrl } from './format'

describe('formatMoney', () => {
  it('always shows two decimals', () => {
    expect(formatMoney('150.0')).toBe('$150.00')
    expect(formatMoney(80)).toBe('$80.00')
  })

  it('groups thousands', () => {
    expect(formatMoney('1234.5')).toBe('$1,234.50')
  })
})

describe('benefitsTotal', () => {
  it('adds amounts that come from the API as strings', () => {
    expect(benefitsTotal([{ monto: '150.0' }, { monto: '80.5' }])).toBe(230.5)
  })

  it('is zero without benefits', () => {
    expect(benefitsTotal([])).toBe(0)
  })
})

describe('mapUrl', () => {
  it('points OpenStreetMap at the coordinates', () => {
    expect(mapUrl({ latitud: 4.65, longitud: -74.08 })).toBe(
      'https://www.openstreetmap.org/?mlat=4.65&mlon=-74.08#map=12/4.65/-74.08',
    )
  })
})
