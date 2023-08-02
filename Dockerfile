# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#  a more recent Go version
# Use a more recent Go version
FROM golang:1.17 AS builder

# Set the working directory and copy the Go application files
WORKDIR /app
COPY main.go .

# Install and fetch Go modules
RUN go mod init app && go get -u github.com/codegangsta/negroni github.com/gorilla/mux github.com/go-redis/redis

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Create a minimal image for deployment
FROM scratch
WORKDIR /app

# Copy the built executable from the builder stage
COPY --from=builder /app/main .

# Set the command to run the application
CMD ["./main"]

# Expose the port on which your Go application listens
EXPOSE 3000


