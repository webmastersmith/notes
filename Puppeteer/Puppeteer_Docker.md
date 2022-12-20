# Puppeteer Docker

# Headful

### Github Actions

- <https://github.com/mujo-code/puppeteer-headful>
-

```ts
browser = await puppeteer.launch({
  args: ['--no-sandbox'],
  executablePath: process.env.PUPPETEER_EXEC_PATH, // set by docker container
  headless: false,
  ...
});
```

**check chrome version to match with puppeteer version**

- <https://pptr.dev/chromium-support/>

```sh
apt list --all-versions chromium && apt list --all-versions google-chrome-stable
# google-chrome-stable/stable 104.0.5112.101-1 amd64
# chromium/stable-security 104.0.5112.101-1~deb11u1 amd64
# chromium/stable 103.0.5060.53-1~deb11u1 amd64
```

```dockerfile
FROM node:18.9.0

RUN  apt-get update \
     # See https://crbug.com/795759
     && apt-get install -yq libgconf-2-4 \
     # Install latest chrome dev package, which installs the necessary libs to
     # make the bundled version of Chromium that Puppeteer installs work.
     && apt-get install -y wget xvfb --no-install-recommends \
     && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
     && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
     && apt-get update \
     && apt-get install -y google-chrome-stable --no-install-recommends \
     && rm -rf /var/lib/apt/lists/*


ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

COPY README.md /

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
```

**entrypoint.sh**

```sh
#!/bin/sh

# Startup Xvfb
Xvfb -ac :99 -screen 0 1280x1024x16 > /dev/null 2>&1 &

# Export some variables
export DISPLAY=:99.0
export PUPPETEER_EXEC_PATH="google-chrome-stable"

# Run commands
cmd=$@
echo "Running '$cmd'!"
if $cmd; then
    # no op
    echo "Successfully ran '$cmd'"
else
    exit_code=$?
    echo "Failure running '$cmd', exited with $exit_code"
    exit $exit_code
fi
```

**github action.yaml**

```yaml
name: 'Puppeteer Headful'
description: 'A GitHub Action / Docker image for Puppeteer, the Headful Chrome Node API so you can test Chrome extensions'
author: 'Jacob Lowe'
inputs:
  args:
    description: 'A command to run inside the container normally this would be a npm script to start testing.'
    required: true
branding:
  icon: 'layout'
  color: 'blue'
runs:
  using: 'docker'
  image: 'Dockerfile'
  args:
    - ${{ inputs.args }}
```

---

- <https://dev.to/cloudx/how-to-use-puppeteer-inside-a-docker-container-568c>

```dockerfile
FROM node:slim

# We don't need the standalone Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Install Google Chrome Stable and fonts
# Note: this installs the necessary libs to make the browser work with Puppeteer.
RUN apt-get update && apt-get install gnupg wget -y && \
  wget --quiet --output-document=- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-archive.gpg && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
  apt-get update && \
  apt-get install google-chrome-stable -y --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*
```

**docker start**

```ts
import puppeteer from 'puppeteer';
const browser = await puppeteer.launch({
  executablePath: '/usr/bin/google-chrome',
  args: [...] // if we need them.
});

```

---

## Premade Docker Images

- <https://freeman.vc/notes/headfull-browsers-beat-headless>
  - <https://github.com/piercefreeman/docker/tree/main/headfull-chromium>

**AWS Lambda**

- <http://pawelgoscicki.com/archives/2022/08/running-puppeteer-on-aws-lambda-in-a-docker-container/>
