// Color settings
const MAXINTENSITY = 1.0;
const MININTENSITY = 0.0;
const MINWV = 400;
const STEPWV = 5;
const NUMWV = 61;
const factorRGB = 100;
const factorLMS = 100;
const factorXYZ = 100;
const normL = 232;
const normM = 190;
const normS = 116;

// Display Settings
const DELAY = 50;

// Size settings
var svgSPD;
var svgLMS;
var svgXYZ;
var width, height, margin;
var graphWidth, graphHeight;

document.addEventListener("DOMContentLoaded", function() {
    svgSPD = document.getElementById("spdGraph");
    svgLMS = document.getElementById("lmsGraph");
    svgXYZ = document.getElementById("xyzGraph");
    width = svgSPD.clientWidth;
    height = svgSPD.clientHeight;
    margin = {top: 20, right: 30, bottom: 30, left: 40};
    graphWidth = width - margin.left - margin.right;
    graphHeight = height - margin.top - margin.bottom;
})