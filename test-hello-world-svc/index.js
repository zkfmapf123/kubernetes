import express from 'express'

const [
    PORT,
    VERSION
] = [
        process.env.PORT,
        process.env.VERSION
    ]

const app = express()

app.get("/", (req, res) => res.status(200).send("hello world"))
app.get("/version", (req, res) => res.status(200).send(`hello : ${VERSION}`))
app.listen(PORT, () => {
    console.log(`connect to ${PORT}`)
})