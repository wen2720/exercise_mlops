docker run --rm -it ^
    -v %cd%/models:/models/ ^
    evaluate:latest /models/model.pth