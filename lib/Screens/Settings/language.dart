completeLanguageName(String lang) {
  lang = lang.toLowerCase();
  for (var element in languagesMap.entries) {
    if (element.value.toLowerCase() == lang) {
      return element.key;
    }
  }
  return lang.toUpperCase();
}

final languagesMap = {
  'All': 'all',
  'Français': 'fr',
  'Català': 'ca',
  'English': 'en',
  'Tiếng Việt': 'vi',
  'ไทย': 'th',
  'Bulgaria': 'bg',
  'العربية': 'ar',
  'Português': 'pt',
  '한국어': 'ko',
  'Português (Brasil)': 'pt-br',
  'Italiano': 'it',
  'Pусский язык': 'ru',
  'Español': 'es',
  'Español (Latinoamérica)': 'es-419',
  'Indonesia': 'id',
  'हिन्दी, हिंदी': 'hi',
  '日本語': 'ja',
  'Polski': 'pl',
  'Türkçe': 'tr',
  'Deutsch': 'de',
  '中文(Zhōngwén)': 'zh',
  '繁體中文(Hong Kong)': 'zh-hk',
  "Filipino": "fil",
  "Ελληνικά": "el",
  "dansk": "da",
  "বাংলা": "bn",
  "Afrikaans": "af",
  "አማርኛ": "am",
  "Azərbaycan": "az",
  "беларуская": "be",
  "bosanski": "bs",
  "svenska": "sv",
  "suomi": "fi",
  "فارسی": "fa",
  "euskara": "eu",
  "Norwegian Bokmål (Norway)": "nb-no",
  "lietuvių kalba": "lt",
  "srpskohrvatski": "sh",
  "Norsk": "no",
  "עברית": "he",
  "Монгол": "mn",
  "മലയാളം": "ml",
  "Українська": "uk",
  "isiZulu": "zu",
  "isiXhosa": "xh",
  "Nederlands": "nl",
  "ဗမာစာ": "my",
  "Malaysia": "ms",
  "Hrvatski": "hr",
  "Română": "ro",
  "български": "bg",
  "čeština": "cs",
  "Kurdî": "ku",
  "Magyar": "hu",
  "Cebuano": "ceb",
  "English (United States)": "en-us",
  "Esperanto": "eo",
  "Estonian": "et",
  "Faroese": "fo",
  "Irish": "ga",
  "Guarani": "gn",
  "Gujarati": "gu",
  "Hausa": "ha",
  "Haitian Creole": "ht",
  "Armenian": "hy",
  "Igbo": "ig",
  "Icelandic": "is",
  "Georgian": "ka",
  "Javanese": "jv",
  "Kazakh": "kk",
  "Cambodian": "km",
  "Kannada": "kn",
  "Kyrgyz": "ky",
  "Luxembourgish": "lb",
  "Laothian": "lo",
  "Latvian": "lv",
  "Malagasy": "mg",
  "Maori": "mi",
  "Macedonian": "mk",
  "Marathi": "mr",
  "Maltese": "mt",
  "Nepali": "ne",
  "Nyanja": "ny",
  "Pashto": "ps",
  "Portuguese (Portugal)": "pt-pt",
  "Romansh": "rm",
  "Sindhi": "sd",
  "Sinhalese": "si",
  "Slovak": "sk",
  "Slovenian": "sl",
  "Samoan": "sm",
  "Shona": "sn",
  "Somali": "so",
  "Albanian": "sq",
  "Serbian": "sr",
  "Sesotho": "st",
  "Swahili": "sw",
  "Tamil": "ta",
  "Tajik": "tg",
  "Tigrinya": "ti",
  "Turkmen": "tk",
  "Tonga": "to",
  "Urdu": "ur",
  "Yoruba": "yo",
  "Chinese (Traditional)": "zh-tw",
  "Latin": "la",
  "Uzbek": "uz",
  "Tagalog": "tl"
};
