# Use golang base image
FROM golang:latest as builder

# Install git
RUN apt-get update && apt-get install -y git

# Set the working directory
WORKDIR /gitleaks

# Clone gitleaks repository
RUN git clone https://github.com/zricethezav/gitleaks.git .

# Build gitleaks
RUN go build -o gitleaks .

# Start a new stage to create a smaller image
FROM debian:latest

# Copy the built gitleaks binary from the builder stage
COPY --from=builder /gitleaks/gitleaks /usr/local/bin/

# Set the working directory for gitleaks
WORKDIR /repo
#WORKDIR /repo/actionsdemos-calculator

#COPY gitleaks.toml /repo/actionsdemos-calculator/

# Install git
RUN apt-get update && apt-get install -y git
RUN pwd && echo tst

# Clone your repository (replace <repository_url> with your actual GitHub repository URL)
# ARG GITHUB_PAT
# RUN git clone https://${GITHUB_PAT}@github.com/Sziman/actionsdemos-calculator.git


# Execute gitleaks scan command
CMD ["gitleaks", "detect", "--verbose", "--no-git", "-c", "/repo/actionsdemos-calculator/gitleaks.toml"]
#CMD ["sleep", "300m"]
