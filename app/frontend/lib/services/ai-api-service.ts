import axios from 'axios'

const url = import.meta.env.VITE_AI_SERVICE_URL

export const aiApiService = axios.create({
  baseURL: url,
  headers: {
    'Content-Type': 'application/json',
  },
})
