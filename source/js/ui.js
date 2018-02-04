var PhotoADayUI = (function () {
	var ui = { 
		useOverlay: true,
		useInPageButtons: false
	};
	
	// getPicture
	//
	// Find the large photo on the page.	

	function getPicture() {
		var pictures = document.getElementsByClassName('photo');
		return ( pictures.length ? pictures[0] : undefined ); 
	}

	function preparePhoto() {
		var picture = getPicture();
		if (picture) {
			setupButtons(picture);
			positionOverlay(picture);
			initializeOverlay(picture);
		}
	}

	function setupButtons(picture) {
		var photobuttons = document.getElementById('photobuttons');
		if (photobuttons) {
			if (ui.useInPageButtons) {
				var previousButton = document.getElementById('back');
				if (previousButton) {
					previousButton.onclick = function(event) {
						goToPrevious(picture);
					}
				}
				var nextButton = document.getElementById('forward');
				if (nextButton) {
					nextButton.onclick = function(event) {
						goToNext(picture);
					}
				}
				photobuttons.style.display = 'block';
			}
			else {
				photobuttons.style.display = 'none';
			}
		}
	}

	function positionOverlay(picture) {
		if (ui.useOverlay) {
			var img = picture.getElementsByTagName('img')[0];
			var overlay = document.getElementById('overlay');
			var istyle = window.getComputedStyle(img,null);
			var pstyle = window.getComputedStyle(picture,null);
			overlay.style.width = istyle.getPropertyValue('width');
			overlay.style.height = istyle.getPropertyValue('height');
			var left = ( parseInt(pstyle.getPropertyValue('width')) - 
						 parseInt(istyle.getPropertyValue('width')) ) / 2;
			overlay.style.left = left + "px";
		}
	}

	function initializeOverlay(picture) {
		if (ui.useOverlay) {
			var overlay = document.getElementById('overlay');
			var leftMarker = document.createElement("div");
			leftMarker.className = 'btnForward';
			var rightMarker = document.createElement("div");
			rightMarker.className = 'btnBack';
			leftMarker.onclick = function(event) {
				goToNext(picture);
			}
			rightMarker.onclick = function(event) {
				goToPrevious(picture);
			}
			overlay.appendChild(leftMarker);
			overlay.appendChild(rightMarker);
		}
	}

	function setupResize() {
		window.onresize = function(event) {
			var picture = getPicture();
			if (picture) {
				positionOverlay(picture);
			}
		}
	}
	
	function goToPrevious(picture) {
		var url = picture.dataset.previous;
		if (url) {
			window.location.href = url;
		}	
	}
	
	function goToNext(picture) {
		var url = picture.dataset.next;
		if (url) {
			window.location.href = url;
		}	
	}
	
	// Initialization
	
	ui.init = function() {
		
		// Once the DOM's ready, prepare the picture UI.
		
		document.addEventListener("DOMContentLoaded", function(event) { 
		  preparePhoto();
		  setupResize();
		});

		// When everything's done loading, use Hammer to add a swipe handler.
		
		window.onload = function(event) {
			var picture = getPicture();
			if (picture) {
				var mc = new Hammer.Manager(picture, {});
				mc.add( new Hammer.Swipe({ direction: Hammer.DIRECTION_HORIZONTAL, threshold: 0 }) );
				mc.on("swipeleft", function (event) { goToNext(picture); });
				mc.on("swiperight", function (event) { goToPrevious(picture); });
			}
		};
		
		// If this is a touch device, we don't need the overlay with guide arrows on it.
		
		window.addEventListener('touchstart', function onFirstTouch() {
			var overlay = document.getElementById('overlay');
			overlay.style.display = 'none';
  			window.removeEventListener('touchstart', onFirstTouch, false);
		}, false);
	};
	
	return ui;

}());