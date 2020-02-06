# BlobToolKit Docker Image

Contains all code and dependencies for [BlobToolKit](https://blobtoolkit.genomehubs.org)

## Running BlobTools2

### Generate a minimal dataset

A minimal dataset can be generated from just an assembly FASTA file. The default user ID inside the container is 1000, on a system with multiple users you may need to set `-u $UID:$GROUPS`.

```
docker run -it --rm --name btk \
           -u $UID:$GROUPS \
           -v /path/to/datasets:/blobtoolkit/datasets \
           -v /path/to/input/data:/blobtoolkit/data \
           genomehubs/blobtoolkit:latest \
           ./blobtools2/blobtools create \
           --fasta data/YOUR_ASSEMBLY.fasta \
           --taxid 1234 \
           --taxdump taxdump \
           datasets/YOUR_DATASET_ID
```


### Add data to a dataset

Most views in the Viewer require additional data to be loaded. The snail plot can be loaded with only assembly information but can optionally display BUSCO results.

To add BUSCO results, use the `blobtools add` command:

```
docker run -it --rm --name btk \
           -u $UID:$GROUPS \
           -v /path/to/datasets:/blobtoolkit/datasets \
           -v /path/to/input/data:/blobtoolkit/data \
           genomehubs/blobtoolkit:latest \
           ./blobtools2/blobtools add \
           --busco data/BUSCO_FULL_TABLE.tsv \
           datasets/YOUR_DATASET_ID
```

See [BlobTools2 Tutorials](https://blobtoolkit.genomehubs.org/blobtools2/blobtools2-tutorials/) for information on adding other analyses.


## Using the Viewer

### Hosting an interactive viewer

Run this image on your local machine and view datasets interactively.

1. Start the container with your dataset-containing directory mounted to `/blobtoolkit/datasets`. (setting `-u $UID:$GROUPS` does not work here):

  ```
  docker run -d --rm --name btk \
             -v /path/to/datasets:/blobtoolkit/datasets \
             -p 8000:8000 -p 8080:8080 \
             -e VIEWER=true \
             genomehubs/blobtoolkit:latest
  ```

2. Open http://localhost:8080/view/all in a web browser


### Generating plots on the command line

Run this image on your local machine and use `docker exec` to run [BlobTools2](https://blobtoolkit.genomehubs.org/blobtools2/) `view` commands.

1. Start the container, mounting an additional directory for output images. The port mapping options used above can be omitted if not accessing the viewer from outside docker:
  ```
  docker run -d --rm --name btk \
             -v /path/to/datasets:/blobtoolkit/datasets \
             -v /path/to/output:/blobtoolkit/output \
             -e VIEWER=true \
             genomehubs/blobtoolkit:latest
  ```

2. Run commands in the same container using `docker exec`. (To write plots to the output directory on a multi-user system, you may need to make sure it is writable by UID 1000 before running these commands):

  - Cumulative plot
    ```
    docker exec -it btk \
                ./blobtools2/blobtools view \
                --host http://localhost:8080 \
                --out output \
                --view cumulative
                YOUR_DATASET_ID
    ```

  - Snail plot
    ```
    docker exec -it btk \
                ./blobtools2/blobtools view \
                --host http://localhost:8080 \
                --out output \
                --view snail
                YOUR_DATASET_ID
    ```


### Accessing Viewer from other containers
For more complex hosting situations additional parameters can be passed to the Viewer using a .env file, such as the one in the `conf` directory of this repository. For example, to access from another container on the same docker network:

1. Create the network:
  ```
  docker network create btk-net
  ```

2. Start the container with a custom configuration (important to ensure host names in `.env` match the container names as in this example):
  ```
  docker run -d --rm --name btk-viewer --network btk-net \
             -v /path/to/datasets:/blobtoolkit/datasets \
             -v /path/to/conf:/blobtoolkit/conf \
             -e VIEWER=true \
             genomehubs/blobtoolkit:latest
  ```

3. Start another container to generate a plot:
  ```
  docker run -it --rm --name btk-blobtools --network btk-net \
              -v /path/to/conf:/blobtoolkit/conf \
              -v /path/to/output:/blobtoolkit/output \
              genomehubs/blobtoolkit:latest \
              ./blobtools2/blobtools view \
              --host http://btk-viewer:8080 \
              --out conf \
              --param plotShape=kite \
              YOUR_DATASET_ID
  ```
