// Get modal and response box elements
const modal = document.getElementById("chatbot-modal");
const responseBox = document.getElementById("response");

// Open chatbot modal
function openChatModal() {
  modal.style.display = "block";
}

// Close chatbot modal
function closeChatModal() {
  modal.style.display = "none";
}

// Close modal when clicking outside
window.onclick = function (event) {
  if (event.target === modal) {
    modal.style.display = "none";
  }
}

// Send message to backend chatbot
function sendMessage(event) {
  if (event) event.preventDefault(); // ✅ Prevent form from submitting as GET

  const inputField = document.getElementById("condition");
  const input = inputField.value.trim();

  if (input) {
    responseBox.innerText = "🔍 Searching for: " + input + "...";
    responseBox.style.display = "block";

    fetch("/chat", {
      method: "POST", // ✅ Keep POST
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ message: input })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("Server returned an error: " + response.status);
      }
      return response.json();
    })
    .then(data => {
      responseBox.innerText = data.response;
      inputField.value = ""; // Clear input
    })
    .catch(error => {
      responseBox.innerText = "❌ Error: " + error.message;
      console.error("Fetch error:", error);
    });
  } else {
    responseBox.innerText = "❌ Please enter a condition.";
  }
}

// Optional: Attach modal open/close listeners
document.querySelector(".learn-more")?.addEventListener("click", openChatModal);
document.querySelector(".close-button")?.addEventListener("click", closeChatModal);
