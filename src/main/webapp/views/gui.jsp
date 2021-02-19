<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>GUI page</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
          integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
</head>
<body>
<!-- Video -->
<h1>CAM <a href="/" class="btn btn-primary">Go to Main Page</a></h1>
<video id="preview"></video>
<!-- Duplicate to canvas -->
<canvas hidden id="myCanvas" width="640" height="480"
        style="background-color:#eee; border:1px solid #ccc;">
    Ваш браузер не поддерживает Canvas
</canvas>
<br>
<!-- Choose cameras (1/2) -->
<div class="btn-group btn-group-toggle mb-2 mt-2" data-toggle="buttons">
    <label class="btn btn-light active">
        <input type="radio" name="options" value="1" autocomplete="off" checked> CAM #1
    </label>
    <label class="btn btn-dark">
        <input type="radio" name="options" value="2" autocomplete="off"> CAM #2
    </label>
</div>
<!-- Image color area -->
<div id="color" class="alert alert-light" role="alert"></div>
<!-- Image (copy from canvas to usage in color lib) -->
<img hidden id="image" width="640px" height="480px">
<!-- 2 lib 1 - color detect/ 2 - load image and scan qr code -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/vibrant.js/1.0.0/Vibrant.js"></script>
<script src="https://rawgit.com/schmich/instascan-builds/master/instascan.min.js"></script>
<!-- load image from cam to <video> and scan qr/bar -->
<script type="text/javascript">
    var scanner = new Instascan.Scanner({video: document.getElementById('preview'), scanPeriod: 5, mirror: false});
    Instascan.Camera.getCameras().then(function (cameras) {
        if (cameras.length > 0) {
            scanner.start(cameras[0]);
            $('[name="options"]').on('change', function () {
                if ($(this).val() == 1) {
                    if (cameras[0] != "") {
                        scanner.start(cameras[0]);
                    } else {
                        alert('No Front camera found!');
                    }
                } else if ($(this).val() == 2) {
                    if (cameras[1] != "") {
                        scanner.start(cameras[1]);
                    } else {
                        alert('No Back camera found!');
                    }
                }
            });
        } else {
            console.error('No cameras found.');
            alert('No cameras found.');
        }
    }).catch(function (e) {
        console.error(e);
        alert(e);
    });
</script>
<!-- copy frame from video to image and canvas -->
<script>
    var canvas = document.getElementById("myCanvas");
    var video = document.getElementById("preview");
    var img = document.getElementById("image");
    video.addEventListener('play', function() {
        context = canvas.getContext("2d");
        draw_interval = setInterval(function() {
            context.drawImage(video, 0, 0, 640, 480);
            img.src = canvas.toDataURL('image/png');
        }, 1000)
    }, false);
</script>
<!-- scan image and scan vibrant color -->
<script>
    var img = document.getElementById("image");
    img.addEventListener('load', function () {
        var vibrant = new Vibrant(img);
        var swatches = vibrant.swatches();
        for (var swatch in swatches)
            if (swatches.hasOwnProperty(swatch) && swatches[swatch]) {
                /*console.log(swatch, swatches[swatch].getHex());
                Vibrant
                Muted
                DarkVibrant
                DarkMuted
                LightVibrant*/
                var color = swatches['Vibrant'].getHex();
                document.getElementById("color").innerHTML = "<div style=\"color: #fff;border: black 1px; background-color:" + color + " \">&nbsp;<h5>&nbsp;" + color + "</h5>&nbsp;</div>";
                img.addEventListener('load', function () {
                    let myData = 'data:application/txt;charset=utf-8,' + encodeURIComponent(color);
                    this.href = myData;
                    this.download = 'color.txt';
                });
            }
    });
</script>
<!-- bootstrap -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
        integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
        crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"
        integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN"
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"
        integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV"
        crossorigin="anonymous"></script>
</body>
</html>