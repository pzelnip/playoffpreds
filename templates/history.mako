${main()}

<%def name="main()">

<!DOCTYPE html>
<html lang="en">
<head>

    <!-- Based upon example from W3C Schools: http://www.w3schools.com/bootstrap/bootstrap_carousel.asp -->

    <title>Bootstrap Example</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
    <style>
        .carousel-inner > .item > img,
        .carousel-inner > .item > a > img {
            width: 70%;
            margin: auto;
        }
    </style>
</head>
<body>
    <div class="text-center">
    This has been a fun little "learn some web dev" project.  Here I'll record some
    of the history of this project in the form of screenshots
    </div>
    
    <div class="container">
        <br>
        <div id="myCarousel" class="carousel slide" data-ride="carousel">

            <!-- Indicators -->
            <ol class="carousel-indicators">

                %for i, image in enumerate(images):
                    <li data-target="#myCarousel" data-slide-to="${i}" ${'class="active"' if i == 0 else ""}></li>
                %endfor
            </ol>

            <!-- Wrapper for slides -->
            <div class="carousel-inner" role="listbox">

                %for i, image in enumerate(images):
                    <div class="item ${'active' if i == 0 else ""}">
                        <div class="bg-info text-center" style="color: #000">
                            <h3>${image.title}</h3>
                            <p>${image.description}</p>
                        </div>

                        <a href="${image.url}">
                        <img src="${image.url}" alt="${image.title}" width="${image.width}" height="${image.height}">
                        </a>
                    </div>
                %endfor
            </div>

            <!-- Left and right controls -->
            <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
                <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                <span class="sr-only">Previous</span>
            </a>
            <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
                <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                <span class="sr-only">Next</span>
            </a>
        </div>
    </div>

    <div class="small text-center">
    Based upon example from W3C Schools: <a href="http://www.w3schools.com/bootstrap/bootstrap_carousel.asp">http://www.w3schools.com/bootstrap/bootstrap_carousel.asp</a>
    </div>
</body>
</html>

</%def>
