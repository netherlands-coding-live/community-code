// - - - - - - - - - - - - - - - - - - - - - - - - - - - //
// - - - - - Choreo-Graphic-Coding by Joana Chicau - - - \\
// - - - - - - - - - - - - - - - - - - - - - - - - - - - //

// stage: https://www.google.com/search?q=all+the+movements
// open the webconsole copy and paste the code below
// call each of the functions and tweak the code as you please!
// note: id's and classes may change, inspect each of the elements when using the code;

function Warning() {
    alert("This is a silent piece, listen to it carefully.");
}

var delay="10";
var count='0';
var Texts=new Array();
Texts[0]="Choreography";
Texts[1]="as a moving language,";
Texts[2]="words to define";
Texts[3]="space and  time";
Texts[4]="expand and contract";
Texts[5]="or remain still.";


function NewSequence(){
document.querySelector('#logocont').innerHTML=Texts[count]; 
count++;
if(count==Texts.length){count='0';}
setTimeout("NewSequence()",delay*1000);

document.querySelector("#logocont").style.width="1000px"
document.querySelector("#logocont").style.fontSize="42pt"
}

var textarray = [
"Ritualistic, repetitive",
"Simultaneously",
"A thing called a body.",
"Breathing until its enough.",
"Substitution.",
"A supermposition of rhythms",
"(variation)",
"Accumulation",
"No time for breathing." 
];


function Elements_of_Chance(n) {

var rannum= Math.floor(Math.random()*textarray.length);
var r =document.querySelector(".g:nth-child("+n+")"),
r = r.querySelector(".r");
r.innerHTML=textarray[rannum];
r.style.fontSize="24pt"
r.style.color="#000"
};

// set Interval("Elements_of_Chance(n)", 1500) - - > n = number starting from 1

// in the webconsole experiment with switching the values of the images element, using:
// transform: matrix3d(1, 1, 0, 0, 10, 1, 0, 10, 10, 0, 1, 0, 200, 10, 0, 1);
// width: 500px;
// filter: grayscale(100%)
// opacity: 0.25;


function leave_the_stage (n){

var r =document.querySelector(".g:nth-child("+n+")");
r.style.visibility="hidden";
};

function offstage () {
    document.body.innerHTML = '';
    document.head.innerHTML = '';      
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - //
// - - - - thank you for coding and dancing along! - - - \\
// - - - - - - - - - - - - - - - - - - - - - - - - - - - //

