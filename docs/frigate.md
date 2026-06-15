# Install and Setup instructions for Frigate

## Introduction

[Frigate](https://frigate.video/) is an open source network video recorder (NVR) with real-time local object detection for IP cameras. It is commonly deployed alongside Home Assistant and supports multiple camera streams, motion review, recordings, and live restreaming.

## Before You Deploy

This Pi-Hosted template creates the standard Frigate folders under:

- `/portainer/Files/AppData/Config/Frigate/config`
- `/portainer/Files/AppData/Config/Frigate/Media`

Make sure these folders exist on the host before deployment:

```bash
sudo mkdir -p /portainer/Files/AppData/Config/Frigate/config
sudo mkdir -p /portainer/Files/AppData/Config/Frigate/Media
```

Frigate also requires a valid configuration file at:

- `/portainer/Files/AppData/Config/Frigate/config/config.yml`

Create that file before starting the stack. A minimal example is shown below.

## Example Minimal Frigate Configuration

```yaml
mqtt:
  enabled: false

cameras:
  front_door:
    ffmpeg:
      inputs:
        - path: rtsp://USERNAME:PASSWORD@CAMERA-IP:554/stream1
          roles:
            - detect
    detect:
      width: 1280
      height: 720
      fps: 5
```

This is only a starting point. Refer to the official Frigate documentation for production-ready camera, detector, recording, and go2rtc configuration.

## Portainer Template Variables

The template exposes the following variables:

- `FRIGATE_WEB_PORT` - Host port mapped to the Frigate web UI (`5000` in the container)
- `FRIGATE_RTSP_PORT` - Host port mapped to Frigate RTSP restreaming (`8554` in the container)
- `FRIGATE_WEBRTC_PORT` - Host UDP port mapped to WebRTC traffic (`8555/udp` in the container)
- `TZ` - Timezone used by the container
- `FRIGATE_CPUS` - CPU limit for the container

Default mappings are:

- `90 -> 5000/tcp`
- `91 -> 8554/tcp`
- `92 -> 8555/udp`

## Installation

Open `Templates` in Portainer and search for **Frigate**.

Review and adjust the variables as needed:

- **FRIGATE_WEB_PORT:** Port for the Frigate web interface
- **FRIGATE_RTSP_PORT:** Port for RTSP restreaming
- **FRIGATE_WEBRTC_PORT:** UDP port for WebRTC
- **TZ:** Your local timezone, for example `Africa/Johannesburg`
- **FRIGATE_CPUS:** CPU quota to assign to the container

Then click `Deploy the stack`.

## Important Notes

### 1. Privileged mode

This template runs Frigate with `privileged: true` because that is the supplied compose configuration. This can be necessary for some hardware-accelerated or device-based setups, but it gives the container broad access to the host. If your installation can be narrowed down later to explicit device mappings and capabilities, that would be a cleaner long-term configuration.

### 2. Hardware acceleration and detectors

Many Frigate deployments need additional configuration beyond this basic template, for example:

- USB Coral TPU
- Intel Quick Sync / VAAPI
- NVIDIA GPU support
- `/dev/video*` or `/dev/dri/*` device mappings

Those requirements vary by hardware and are not included in this initial template. Follow the official Frigate docs for your specific platform.

### 3. First startup

If the stack starts but Frigate does not become healthy, the first thing to check is the mounted configuration file:

```bash
/portainer/Files/AppData/Config/Frigate/config/config.yml
```

Invalid YAML or an incorrect camera stream URL is the most common startup problem.

## After Installation

Open Frigate in your browser using:

```text
http://<HOST-IP>:<FRIGATE_WEB_PORT>
```

Using the default template values, that is:

```text
http://<HOST-IP>:90
```

## References

- Official site: <https://frigate.video/>
- Official docs: <https://docs.frigate.video/>
- Source code: <https://github.com/blakeblackshear/frigate>
