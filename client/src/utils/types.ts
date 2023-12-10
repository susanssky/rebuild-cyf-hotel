export type UserDataType = {
  id: number
  title: string
  first_name: string
  surname: string
  email: string
}

export type BookingsType = UserDataType & {
  roomId: number
  check_in_date: string
  check_out_date: string
  [key: string]: string | number
}

export type ProfileDataType = UserDataType & {
  vip: boolean
  phoneNumber: string
}
export type InitialStateType = Omit<UserDataType, 'id'> & {
  roomId: string
  check_in_date: string
  check_out_date: string
  firstNameError: string
  surnameError: string
  emailError: string
  roomIdError: string
  titleError: string
}
export type FormErrorContextProviderType = {
  isFormError: boolean
  setIsFormError: React.Dispatch<React.SetStateAction<boolean>>
}
