const money = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' })

// Amounts arrive from Rails as decimal strings ("150.0").
export function formatMoney(value) {
  return money.format(Number(value))
}

export function benefitsTotal(benefits) {
  return benefits.reduce((sum, benefit) => sum + Number(benefit.monto), 0)
}

export function mapUrl({ latitud, longitud }) {
  return `https://www.openstreetmap.org/?mlat=${latitud}&mlon=${longitud}#map=12/${latitud}/${longitud}`
}
