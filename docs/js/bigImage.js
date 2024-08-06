document.addEventListener('DOMContentLoaded', function() {
    var images = [
        { src: "http://brainden.com/images/static1-big.jpg", caption: "Engage your eyes on the image. Everything starts spinning." },
        { src: "http://brainden.com/images/static3.gif", caption: "The motion is just an illusion." },
        { src: "http://brainden.com/images/bicycle.gif", caption: "Riding a bicycle." },
        { src: "http://brainden.com/images/moving-waves-illusion.png", caption: "Imagine if this was your carpet." },
        { src: "http://brainden.com/images/ricewave-big.gif", caption: "The patterns resemble your eye's encoding of motion." },
        { src: "http://brainden.com/images/moving-maze-illusion-big.jpg", caption: "A-MAZE." },
        { src: "http://brainden.com/images/centralpoint-big.gif", caption: "Focus on the dot and move your head closer." },
        { src: "http://brainden.com/images/same-color-illusion-big.png", caption: "Observe. A and B are actually the same shade." },
        { src: "http://brainden.com/images/white-illusion-big.jpg", caption: "These are the same gray." },
        { src: "http://brainden.com/images/color-cube-big.jpg", caption: "A, B, and C are the same brown." },
        { src: "http://brainden.com/images/identical-colors-big.jpg", caption: "A and B are the exact same. The context matters." },
        { src: "http://brainden.com/images/yellow-blue-dogs-big.jpg", caption: "Blue Dog and Yellow Dog -- the same!" },
        { src: "http://brainden.com/images/chess-pieces-big.jpg", caption: "Cinematic Chess Set." },
        { src: "http://brainden.com/images/red-green-big.gif", caption: "Can you guess what's this about?" },
        { src: "http://brainden.com/images/grey-blue-stripe.gif", caption: "Focus on the black dot for a blue surprise." },
        { src: "http://brainden.com/images/rotating-dots-big.gif", caption: "Focus on the dot. Green will appear. Focus longer. Pink will disappear." },
        { src: "http://brainden.com/images/cafe-wall-big.gif", caption: "The gray lines are straight!" },
        { src: "http://brainden.com/images/blue-horizontal-lines-big.jpg", caption: "The blue bars are parallel to each other." },
        { src: "http://brainden.com/images/hering-illusion-big.gif", caption: "The rays make the two lines seem convex, but they are parallel." },
        { src: "http://brainden.com/images/circle-big.gif", caption: "A distorted, but still perfect circle." },
        { src: "http://brainden.com/images/tilting-table-big.gif", caption: "The boxes are actually parallel." },
        { src: "http://brainden.com/images/no-spiral-big.jpg", caption: "There is no spiral---it's virtual." },
        { src: "http://brainden.com/images/square-big.gif", caption: "Can you guess?" },
        { src: "http://brainden.com/images/parall2-big.gif", caption: "Lines are an illusion." },
        { src: "http://brainden.com/images/straight-dice-big.gif", caption: "You'd rather not have a carpet made of dice." },
        { src: "http://brainden.com/images/shepard-tables-illusion-big.gif", caption: "The table surfaces are actually the exact same shape." },
        { src: "http://brainden.com/images/jastrow-illusion-big.jpg", caption: "A is in fact the same length as B." },
        { src: "http://brainden.com/images/dots-big.gif", caption: "You've seen this one before." },
        { src: "http://brainden.com/images/ponzo-big.jpg", caption: "Depth is an illusion. The green lines are the same length." },
        { src: "http://brainden.com/images/helicopters-big.jpg", caption: "The propellers have the same diameter." }
    ];

    var imageGrid = document.getElementById('image-grid');

    images.forEach(function(image, index) {
        var colDiv = document.createElement('div');
        colDiv.className = 'col-lg-2 col-md-4 col-sm-6 col-12 mb-4';

        var imageContainer = document.createElement('div');
        imageContainer.className = 'image-container';
        imageContainer.setAttribute('data-bs-toggle', 'modal');
        imageContainer.setAttribute('data-bs-target', '#imageModal');
        imageContainer.setAttribute('data-bs-image', image.src);
        imageContainer.setAttribute('data-bs-caption', image.caption);

        var img = document.createElement('img');
        img.src = image.src;
        img.alt = `Image ${index + 1}`;
        img.className = 'img-fluid';

        var overlay = document.createElement('div');
        overlay.className = 'overlay';
        overlay.textContent = image.caption;

        imageContainer.appendChild(img);
        imageContainer.appendChild(overlay);
        colDiv.appendChild(imageContainer);
        imageGrid.appendChild(colDiv);
    });

    var imageModal = document.getElementById('imageModal');
    imageModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var imageSrc = button.getAttribute('data-bs-image');
        var imageCaption = button.getAttribute('data-bs-caption');

        var modalImage = imageModal.querySelector('#modalImage');
        var modalCaption = imageModal.querySelector('#modalCaption');

        modalImage.src = imageSrc;
        modalCaption.textContent = imageCaption;
    });
});