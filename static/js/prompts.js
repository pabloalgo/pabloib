// ============================================
// PABLO IB - Prompts Copy to Clipboard
// ============================================

document.addEventListener('DOMContentLoaded', () => {
  const copyButtons = document.querySelectorAll('[data-copy-target]');

  copyButtons.forEach(btn => {
    btn.addEventListener('click', async () => {
      const targetId = btn.getAttribute('data-copy-target');
      const targetEl = document.getElementById(targetId);
      if (!targetEl) return;

      const text = targetEl.textContent || targetEl.innerText;

      try {
        await navigator.clipboard.writeText(text.trim());

        // Visual feedback
        const iconEl = btn.querySelector('[data-copy-icon]');
        const labelEl = btn.querySelector('[data-copy-label]');

        if (iconEl) {
          iconEl.textContent = 'check';
          iconEl.style.color = '#4ade80';
        }
        if (labelEl) {
          labelEl.textContent = '¡Copiado!';
        }

        // Reset after 2 seconds
        setTimeout(() => {
          if (iconEl) {
            iconEl.textContent = 'content_copy';
            iconEl.style.color = '';
          }
          if (labelEl) {
            labelEl.textContent = 'Copiar';
          }
        }, 2000);
      } catch (err) {
        console.error('Failed to copy prompt:', err);
      }
    });
  });
});
