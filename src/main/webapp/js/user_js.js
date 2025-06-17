/* 
    Author     : Fiza
*/
       
function confirmLogout(event) {
    event.preventDefault(); // Prevent link from navigating
    if (confirm("Are you sure you want to logout?")) {
        window.location.href = "LogoutServlet"; // Redirect only if confirmed
    }
}

function toggleMenu() {
const nav = document.getElementById('navLinks');
nav.style.display = nav.style.display === 'block' ? 'none' : 'block';
}

// Close dropdown if clicking outside
window.onclick = function(event) {

    if (!event.target.closest('.burger-menu') && !event.target.closest('#navLinks')) {
        const navLinks = document.getElementById('navLinks');
        if (navLinks) {
            navLinks.style.display = 'none';
        }
    }
};