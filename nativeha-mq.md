# Considerations for Configuring MQ for Persistent Storage/NativeHA

- [Overview](#overview)
- 

## Overview
- There are a few considerations to take with IBM MQ NativeHA Queue Managers on OpenShift Container Platform.
- Persistent Volume Storage Classes
- Supplemental Groups for Security Context - which also relates to PVC Storage Classes

## Persistent Volumes
- IBM MQ NativeHA/Multi-Instance will require RWO type Storage Classes of Gold. On IBM Cloud/ROKS you can use storage classes like `ibmc-file-gold`. However, this will encounter issues with write access to the file system.
- Of some of the related permissin related errors will be something like the following:
```
mkdir /mnt/mqm/data: permission denied
```
```
Error 71 creating queue manager: Permission denied attempting to access an INI file.
```
- To remedy use a storage class such as `ibmc-file-gold-gid`.
- You will also need to add a `securityContext` field to your QueueManager yaml. The `supplementalGroups` value of 99 will provide sufficient enough context for the NativeHA MQ pods.
```yaml
spec:
  securityContext:
    supplementalGroups:
      - 99
```

## 