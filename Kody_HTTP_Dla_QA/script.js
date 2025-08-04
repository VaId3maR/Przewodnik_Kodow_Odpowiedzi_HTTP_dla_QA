// Funkcja wyszukiwania
function filterCodes() {
    const searchTerm = document.getElementById('search').value.toLowerCase();
    const statusCodes = document.querySelectorAll('.status-code');
    const checklistSections = document.querySelectorAll('.checklist-section'); // DODANE
    
    statusCodes.forEach(code => {
        const text = code.textContent.toLowerCase();
        if (text.includes(searchTerm)) {
            code.style.display = 'block';
        } else {
            code.style.display = 'none';
        }
    });
    
    // DODANE - wyszukiwanie w checkliście
    checklistSections.forEach(section => {
        const text = section.textContent.toLowerCase();
        if (text.includes(searchTerm)) {
            section.style.display = 'block';
        } else {
            section.style.display = 'none';
        }
    });
}

// Funkcja filtrowania po kategoriach
function filterByCategory(category) {
    const statusCodes = document.querySelectorAll('.status-code');
    const checklistSections = document.querySelectorAll('.checklist-section'); // DODANE
    const buttons = document.querySelectorAll('.categories button');
    
    // Usuń aktywną klasę ze wszystkich przycisków
    buttons.forEach(btn => btn.classList.remove('active'));
    
    // Dodaj aktywną klasę do klikniętego przycisku
    event.target.classList.add('active');
    
    // Obsługa status codes
    statusCodes.forEach(code => {
        if (category === 'all') {
            code.style.display = 'block';
        } else {
            const codeCategory = code.getAttribute('data-category');
            if (codeCategory === category) {
                code.style.display = 'block';
            } else {
                code.style.display = 'none';
            }
        }
    });
    
    // DODANE - obsługa checklisty
    checklistSections.forEach(section => {
        if (category === 'all' || category === 'checklist') {
            section.style.display = 'block';
        } else {
            section.style.display = 'none'; // UKRYJ gdy klikasz 1xx, 2xx, etc.
        }
    });
}

// Funkcja do smooth scroll do sekcji
function scrollToSection(sectionId) {
    document.getElementById(sectionId).scrollIntoView({
        behavior: 'smooth'
    });
}

// Pokaż/ukryj przycisk w zależności od scrolla
window.addEventListener('scroll', function() {
    const btn = document.getElementById('scrollToTopBtn');
    if (window.scrollY > 300) {
        btn.style.display = 'block';
    } else {
        btn.style.display = 'none';
    }
});

// Obsługa kliknięcia
document.getElementById('scrollToTopBtn').addEventListener('click', function() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
});