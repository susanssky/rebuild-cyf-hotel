// export type ClientType = {
//   user: string
//   host: string
//   database: string
//   password: string
//   port: number
//   ssl: { rejectUnauthorized: boolean }
// }
export type ClientType = {
  connectionString: string
  ssl: { rejectUnauthorized: boolean }
}

export type CustomerDataType = {
  id: number
  title: string
  firstName: string
  surname: string
  email: string
  roomId: number
  checkInDate: string
  checkOutDate: string
}
