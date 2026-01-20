// Game State
const state = {
    timeLeft: 7200, // 2 hours in seconds
    isHydrated: true,
    startDate: null,
    level: 1,
    messages: [
        "BUBBLUu, I love you! 💕", "BUBBLUu, ADITHYA SAYS HI!!! ✨", "BUBBLUu, ADITHYA SAYS MWAHH.. 💋",
        "BUBBLUu, I missed you so much!! 🌸", "BUBBLUu, say HI to Adithya! 👋", "You look like a pink princess today, BUBBLUu!",
        "Adithya told me to tell you you're the best! 💖", "BUBBLUu, stop being so cute! 🎀", "A hug from me to BUBBLUu! 🤗",
        "BUBBLUu, you're the star of my galaxy!", "Drink up, BUBBLUu-baby! 💧", "Adithya is proud of you, BUBBLUu!"
    ]
};

// Generate more messages
for (let i = 1; i <= 50; i++) {
    state.messages.push(`BUBBLUu: Adithya sent kiss #${i}! 💋`);
    state.messages.push("BUBBLUu, you are glowing! ✨");
    state.messages.push("Adithya says: BUBBLUu is my #1! 💖");
}

// DOM Elements
const timerDisplay = document.getElementById('timer');
const progressFill = document.getElementById('progress-fill');
const levelDisplay = document.getElementById('level-display');
const messageBubble = document.getElementById('message-bubble');
const messageText = document.getElementById('message-text');
const mascot = document.getElementById('mascot');

// Initialization
function init() {
    loadState();
    startTimer();
    updateGrowth();
    setupEventListeners();
    setupCanvas();
}

function loadState() {
    const storedStart = localStorage.getItem('hita_start_time');
    if (!storedStart) {
        state.startDate = new Date();
        localStorage.setItem('hita_start_time', state.startDate.toISOString());
    } else {
        state.startDate = new Date(storedStart);
    }

    // Restore timer if possible or just reset to 2 hours for simplicity in this version
    // Ideally we diff the time, but for a simple "companion" app, resetting on load or keeping static is okay. 
    // Let's try to make it persist slightly better by saving last timestamp? 
    // For now, simple 2 hour countdown from load/action is fine as per original app logic which seemed ephemeral.
}

// Timer Logic
function startTimer() {
    setInterval(() => {
        if (state.timeLeft > 0) {
            state.timeLeft--;
            updateTimerUI();
        } else {
            if (state.isHydrated) {
                state.isHydrated = false;
                triggerNotification("BUBBLUu - THIRSTY!", "Time to drink water! 💧");
            }
        }
    }, 1000);
}

function updateTimerUI() {
    const hrs = Math.floor(state.timeLeft / 3600);
    const mins = Math.floor((state.timeLeft % 3600) / 60);
    const secs = state.timeLeft % 60;
    
    timerDisplay.textContent = `${pad(hrs)}:${pad(mins)}:${pad(secs)}`;
    
    const progress = state.timeLeft / 7200;
    progressFill.style.width = `${progress * 100}%`;
}

function pad(num) {
    return num.toString().padStart(2, '0');
}

function hydrate() {
    state.timeLeft = 7200;
    state.isHydrated = true;
    updateTimerUI();
    triggerNotification("Success!", "Great job BUBBLUu! We are both hydrated! 💧");
    // Play sound if available
    // new Audio('bark.mp3').play().catch(() => {}); 
}

// Growth & Levels
function updateGrowth() {
    const now = new Date();
    const diffTime = Math.abs(now - state.startDate);
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
    
    state.level = diffDays;
    levelDisplay.textContent = `LEVEL ${state.level} COMPANION`;
    
    // Growth scale
    const scale = Math.min(1.4, 1.0 + (diffDays * 0.02));
    mascot.style.transform = `scale(${scale})`; // Note: CSS hover effect might conflict, but base scale is set here.
}

// Messages
function talkToIt() {
    const msg = state.messages[Math.floor(Math.random() * state.messages.length)];
    messageText.textContent = msg;
    messageBubble.classList.remove('hidden');
    
    // Play sound
    // new Audio('meow.mp3').play().catch(() => {});

    setTimeout(() => {
        messageBubble.classList.add('hidden');
    }, 3000);
}

// Notifications configuration
function triggerNotification(title, body) {
    if (!("Notification" in window)) return;
    
    if (Notification.permission === "granted") {
        new Notification(title, { body: body, icon: 'original_panda.jpg' });
    } else if (Notification.permission !== "denied") {
        Notification.requestPermission().then(permission => {
            if (permission === "granted") {
                new Notification(title, { body: body, icon: 'original_panda.jpg' });
            }
        });
    }
}

// Event Listeners
function setupEventListeners() {
    document.getElementById('hydrate-btn').addEventListener('click', hydrate);
    document.getElementById('talk-btn').addEventListener('click', talkToIt);
    
    // Modal
    const modal = document.getElementById('drawing-modal');
    document.getElementById('draw-btn').addEventListener('click', () => {
        modal.classList.remove('hidden');
    });
    document.getElementById('close-draw').addEventListener('click', () => {
        modal.classList.add('hidden');
    });
    document.getElementById('save-draw-btn').addEventListener('click', () => {
        modal.classList.add('hidden');
        triggerNotification("Art Saved!", "Your drawing has been saved to the void (for now)! ✨");
        // Implementing download/save is complex for PWA without file system API, 
        // usually we just download to camera roll.
        const canvas = document.getElementById('drawing-canvas');
        const link = document.createElement('a');
        link.download = 'bubbluu-art.png';
        link.href = canvas.toDataURL();
        link.click();
    });
}

// Canvas
function setupCanvas() {
    const canvas = document.getElementById('drawing-canvas');
    const ctx = canvas.getContext('2d');
    let isDrawing = false;
    let lastX = 0;
    let lastY = 0;

    // Line style
    ctx.strokeStyle = '#ff4d94';
    ctx.lineJoin = 'round';
    ctx.lineCap = 'round';
    ctx.lineWidth = 6;

    function draw(e) {
        if (!isDrawing) return;
        
        // Handle touch or mouse
        let clientX = e.type.includes('touch') ? e.touches[0].clientX : e.clientX;
        let clientY = e.type.includes('touch') ? e.touches[0].clientY : e.clientY;
        
        // Get correct coordinates relative to canvas
        const rect = canvas.getBoundingClientRect();
        const x = clientX - rect.left;
        const y = clientY - rect.top;

        ctx.beginPath();
        ctx.moveTo(lastX, lastY);
        ctx.lineTo(x, y);
        ctx.stroke();
        [lastX, lastY] = [x, y];
    }

    canvas.addEventListener('mousedown', (e) => {
        isDrawing = true;
        const rect = canvas.getBoundingClientRect();
        [lastX, lastY] = [e.clientX - rect.left, e.clientY - rect.top];
    });
    canvas.addEventListener('mousemove', draw);
    canvas.addEventListener('mouseup', () => isDrawing = false);
    canvas.addEventListener('mouseout', () => isDrawing = false);
    
    // Touch support
    canvas.addEventListener('touchstart', (e) => {
        e.preventDefault(); // Prevent scrolling
        isDrawing = true;
        const rect = canvas.getBoundingClientRect();
        [lastX, lastY] = [e.touches[0].clientX - rect.left, e.touches[0].clientY - rect.top];
    }, {passive: false});
    canvas.addEventListener('touchmove', (e) => {
        e.preventDefault(); // Prevent scrolling
        draw(e);
    }, {passive: false});
    canvas.addEventListener('touchend', () => isDrawing = false);

    document.getElementById('erase-btn').addEventListener('click', () => {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
    });
}

// Initial Star generation (using DOM for CSS animations)
const starContainer = document.getElementById('star-container');
for (let i = 0; i < 30; i++) {
    const star = document.createElement('div');
    star.className = 'star';
    star.textContent = '★';
    star.style.left = `${Math.random() * 100}%`;
    star.style.top = `${Math.random() * 100}%`;
    star.style.animationDelay = `${Math.random() * 3}s`;
    star.style.fontSize = `${Math.random() * 10 + 5}px`;
    starContainer.appendChild(star);
}

// Start
init();
