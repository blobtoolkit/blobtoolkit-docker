


```
docker run -d --rm --name btk \
           -v /Users/rchallis/projects/blobtoolkit/viewer/test/files/datasets:/blobtoolkit/datasets \
           -p 8000:8000 -p 8080:8080 \
           -e VIEWER=true \
           genomehubs/blobtoolkit:latest

docker exec -it btk \
            ./blobtools2/blobtools view \
            --host http://localhost:8080 \
            --out datasets \
            ACVV01
```


```
docker network create btk-net
docker run -d --rm --name btk-viewer --network btk-net \
           -v /Users/rchallis/projects/blobtoolkit/viewer/test/files/datasets:/blobtoolkit/datasets \
           -v /Users/rchallis/projects/blobtoolkit/blobtoolkit-docker/conf:/blobtoolkit/conf \
           -e VIEWER=true \
           genomehubs/blobtoolkit:latest

docker logs -f btk-viewer
  ...
  ℹ ｢wdm｣: Compiled successfully.

docker run -it --rm --name btk-blobtools --network btk-net \
            -v /Users/rchallis/projects/blobtoolkit/blobtoolkit-docker/conf:/blobtoolkit/conf \
            genomehubs/blobtoolkit:latest \
            ./blobtools2/blobtools view \
            --host http://btk-viewer:8080 \
            --out conf \
            --param plotShape=kite \
            ACVV01
```

```
docker run -it --rm --name btk-blobtools --network btk-net -v /Users/rchallis/projects/blobtoolkit/blobtoolkit-docker/conf:/blobtoolkit/conf genomehubs/blobtoolkit:latest             firefox --headless --screenshot conf/test.jpg 'http://btk-viewer:8080/view/dataset/ACVV01/blob?staticThreshold=Infinity&nohitThreshold=Infinity&plotGraphics=svg'
```
