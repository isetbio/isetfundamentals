document.addEventListener('DOMContentLoaded', function() {
    var images = [
        { src: "assets/illusions/static1-big.jpg", caption: "Engage your eyes on the image. Everything starts spinning." },
        { src: "assets/illusions/static3.gif", caption: "The motion is just an illusion." },
        { src: "assets/illusions/bicycle.gif", caption: "Riding a bicycle." },
        { src: "assets/illusions/moving-waves-illusion.png", caption: "Imagine if this was your carpet." },
        { src: "assets/illusions/ricewave-big.gif", caption: "The patterns resemble your eye's encoding of motion." },
        { src: "assets/illusions/moving-maze-illusion-big.jpg", caption: "A-MAZE." },
        { src: "assets/illusions/centralpoint-big.gif", caption: "Focus on the dot and move your head closer." },
        { src: "assets/illusions/same-color-illusion-big.png", caption: "Observe. A and B are actually the same shade." },
        { src: "assets/illusions/white-illusion-big.jpg", caption: "These are the same gray." },
        { src: "assets/illusions/color-cube-big.jpg", caption: "A, B, and C are the same brown." },
        { src: "assets/illusions/identical-colors-big.jpg", caption: "A and B are the exact same. The context matters." },
        { src: "assets/illusions/yellow-blue-dogs-big.jpg", caption: "Blue Dog and Yellow Dog -- the same!" },
        { src: "assets/illusions/chess-pieces-big.jpg", caption: "Cinematic Chess Set." },
        { src: "assets/illusions/red-green-big.gif", caption: "Can you guess what's this about?" },
        { src: "assets/illusions/grey-blue-stripe.gif", caption: "Focus on the black dot for a blue surprise." },
        { src: "assets/illusions/rotating-dots-big.gif", caption: "Focus on the dot. Green will appear. Focus longer. Pink will disappear." },
        { src: "assets/illusions/cafe-wall-big.gif", caption: "The gray lines are straight!" },
        { src: "assets/illusions/blue-horizontal-lines-big.jpg", caption: "The blue bars are parallel to each other." },
        { src: "assets/illusions/hering-illusion-big.gif", caption: "The rays make the two lines seem convex, but they are parallel." },
        { src: "assets/illusions/circle-big.gif", caption: "A distorted, but still perfect circle." },
        { src: "assets/illusions/tilting-table-big.gif", caption: "The boxes are actually parallel." },
        { src: "assets/illusions/no-spiral-big.jpg", caption: "There is no spiral---it's virtual." },
        { src: "assets/illusions/square-big.gif", caption: "Can you guess?" },
        { src: "assets/illusions/parall2-big.gif", caption: "Lines are an illusion." },
        { src: "assets/illusions/straight-dice-big.gif", caption: "You'd rather not have a carpet made of dice." },
        { src: "assets/illusions/shepard-tables-illusion-big.gif", caption: "The table surfaces are actually the exact same shape." },
        { src: "assets/illusions/jastrow-illusion-big.jpg", caption: "A is in fact the same length as B." },
        { src: "assets/illusions/dots-big.gif", caption: "You've seen this one before." },
        { src: "assets/illusions/ponzo-big.jpg", caption: "Depth is an illusion. The green lines are the same length." },
        { src: "assets/illusions/helicopters-big.jpg", caption: "The propellers have the same diameter." }
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