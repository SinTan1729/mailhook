# ---------- Build Stage ----------
FROM golang:1-alpine AS builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -ldflags="-s -w" -o mailhook ./cmd/mailhook/main.go
RUN ls

# ---------- Final Stage ----------
FROM alpine:3

WORKDIR /app
COPY --from=builder /src/mailhook /app/mailhook
ENTRYPOINT ["/app/mailhook"]

