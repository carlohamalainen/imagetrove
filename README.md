# ImageTrove

ImageTrove! Powered by MyTARDIS.

## Architecture

    TODO

# Installation

## Install Docker

Follow the instructions at https://docs.docker.com/installation/#installation

While not necessary, running Docker with AUFS makes building containers much faster. You can
check if AUFS is enabled by looking at the ```Storage Driver``` field:

    $ sudo docker info
    Containers: 22
    Images: 652
    Storage Driver: aufs
     Root Dir: /var/lib/docker/aufs
     Dirs: 696
    Execution Driver: native-0.2
    Kernel Version: 3.14.0-2-amd64
    Operating System: Debian GNU/Linux jessie/sid (containerized)
    WARNING: No memory limit support
    WARNING: No swap limit support

## Clone ImageTrove

    git clone https://github.com/carlohamalainen/imagetrove
    cd imagetrove
    git clone git://github.com/carlohamalainen/mytardis.git # current dev fork; later will be git://github.com/mytardis/mytardis.git
    cd mytardis
    cd ..

## Configuration

Look for ```CHANGEME``` in ```create_admin.py```,
```postgresql_first_run.sh```, and ```settings.py```.

To use AAF authentication you must register your service at https://rapid.aaf.edu.au
For the purposes of testing you can use a plain ```http``` callback URL, but for production
you need a ```https``` callback. So this means signed certificates.

## Build the ImageTrove container

    sudo docker build -t='user/imagetrove' .

## Configure volumes

The container uses external volumes for persistent storage.

* ```mytardis_staging```: the MyTARDIS staging directory.
* ```mytardis_store```: the final place that MyTARDIS stores data.
* ```data```: postgresql database files.
* ```var_log```: logfiles for supervisord, postgresql, mytardis, etc.
* ```dicom_tmp```: temporary storage for the local DICOM server.

Ideally ```mytardis_staging```, ```mytardis_store```, and
```dicom_tmp``` would be on the same file system.

## Configure DICOM modalities

On your instrument, add the ImageTrove DICOM modality,
which is a ```STORESCP``` server.  For example, to
configure [Orthanc](http://orthanc-server.com/) add this to ```Configuration.json```:

    // The list of the known DICOM modalities
    "DicomModalities" : {
    "ImageTrove" : [ "STORESCP", "imagetrove.example.com", 5000 ]
    },

# Running ImageTrove

Create directories for the persistent storage:

    mkdir -p /somewhere/mytardis_staging    \
             /somewhere/mytardis_store      \
             /somewhere/data                \
             /somewhere/var_log/supervisor  \
             /somewhere/dicom_tmp

Run the container:

    sudo docker run -i -t --rm                              \
        -p 0.0.0.0:3022:22                                  \
        -p 0.0.0.0:8000:8000                                \
        -v /somewhere/mytardis_staging:/mytardis_staging    \
        -v /somewhere/mytardis_store:/mytardis_store        \
        -v /somewhere/data:/data                            \
        -v /somewhere/var_log:/var/log                      \
        -v /somewhere/dicom_tmp:/dicom_tmp                  \
        -P user/imagetrove

Now go to http://localhost:8000 and you should see the default MyTARDIS front page.

# TODO

* DICOM fields
* Configure ingestion application
* Apache or Nginx instead of django-runserver.
* How to use command line interface.
* pynetdicom to dump files on volume
