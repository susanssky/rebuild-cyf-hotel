import { useState } from 'react'
import moment from 'moment'
import { BookingsType } from './utils/types'

type PropsType = {
  data: BookingsType
  getId: (id: number) => void
}

const Result = ({
  data: {
    id,
    title,
    first_name,
    surname,
    email,
    room_id,
    check_in_date,
    check_out_date,
  },
  getId,
}: PropsType) => {
  const [isActive, setIsActive] = useState<boolean>(false)
  const toggleBg = () => {
    setIsActive((current: boolean) => !current)
  }

  return (
    <tr
      style={{ backgroundColor: isActive ? 'yellow' : '' }}
      onClick={toggleBg}
    >
      <th scope='row'>{id}</th>
      <td>{title}</td>
      <td>{first_name}</td>
      <td>{surname}</td>
      <td>{email}</td>
      <td>{room_id}</td>
      <td>{check_in_date}</td>
      <td>{check_out_date}</td>
      <td>{moment(check_out_date).diff(moment(check_in_date), 'days')}</td>
      <td>
        <button className='btn btn-primary' onClick={() => getId(id)}>
          Show profile
        </button>
      </td>
    </tr>
  )
}

export default Result
