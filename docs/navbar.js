// navbar.js
document.addEventListener("DOMContentLoaded", function() {
    fetch('navbar.html')
        .then(response => response.text())
        .then(data => {
            // Extract the <head> content and insert it into the document head
            const headContent = data.match(/<head[^>]*>([\s\S]*?)<\/head>/i);
            if (headContent) {
                document.head.innerHTML += headContent[1];
            }
            // Remove the head part from data and insert the rest into the navbar div
            const bodyContent = data.replace(/<head[^>]*>([\s\S]*?)<\/head>/i, '');
            document.getElementById('navbar').innerHTML = bodyContent;
        })
        .catch(error => console.error('Error loading navbar:', error));
});