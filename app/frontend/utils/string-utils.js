export function normalizeText(text) {
    return text
      .trim()
      .normalize("NFD") // separa caracteres com acento do caractere base
      .replace(/[\u0300-\u036f]/g, "") // remove os sinais diacríticos
      .toLowerCase();
}