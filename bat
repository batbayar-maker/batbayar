<!DOCTYPE html>
<html lang="mn">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Дэлхийн Лавлах - Offline Pro</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;0,700;1,300;1,600&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
/* ТАНЫ ҮНДСЭН ГУАЙ САЙХАН ЗАГВАР */
:root {
  --bg: #080b10;
  --surface: #0f1419;
  --surface2: #161c24;
  --border: rgba(255,255,255,0.07);
  --gold: #d4a94a;
  --gold2: #f0c96a;
  --silver: #a8b4c0;
  --white: #f0f4f8;
  --accent: #4a90d4;
}

*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
body {
  font-family: 'Outfit', sans-serif;
  background: var(--bg);
  color: var(--white);
  min-height: 100vh;
  overflow-x: hidden;
}

/* HERO SECTION */
.hero {
  min-height: 80vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
  padding: 60px 30px;
  text-align: center;
}

.orb {
  position: absolute; border-radius: 50%; filter: blur(80px); pointer-events: none; opacity: 0.3;
}
.orb1 { width:500px; height:500px; background:radial-gradient(circle, var(--gold), transparent); top:-100px; left:-100px; }
.orb2 { width:400px; height:400px; background:radial-gradient(circle, var(--accent), transparent); bottom:-50px; right:-50px; }

.hero-title {
  font-family: 'Cormorant Garamond', serif;
  font-size: clamp(3rem, 8vw, 6rem);
  font-weight: 300; line-height: 0.9; margin-bottom: 20px;
}
.hero-title strong {
  font-weight: 700; font-style: italic;
  background: linear-gradient(135deg, var(--gold), #fff);
-webkit-background-clip: text; -webkit-text-fill-color: transparent;
}

/* SEARCH BOX */
.search-outer { position: relative; width: 100%; max-width: 550px; margin-top: 40px; }
.search-inner {
  background: var(--surface); border: 1px solid var(--border);
  border-radius: 50px; padding: 5px 25px; display: flex; align-items: center; gap: 15px;
}
#searchInput {
  flex: 1; background: transparent; border: none; color: white; padding: 15px 0;
  font-family: 'Outfit', sans-serif; font-size: 16px; outline: none;
}

/* GRID & CARDS */
.main { max-width: 1400px; margin: 0 auto; padding: 50px 30px; }
.grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 2px; }

.card {
  position: relative; background: var(--surface); overflow: hidden; cursor: pointer; height: 280px;
}
.card-flag { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; opacity: 0.25; transition: 0.6s; }
.card:hover .card-flag { opacity: 0.4; transform: scale(1.05); }
.card-glass {
  position: relative; z-index: 2; padding: 30px; height: 100%;
  display: flex; flex-direction: column; justify-content: space-between;
  border: 1px solid var(--border);
}
.card-name { font-family: 'Cormorant Garamond', serif; font-size: 2.2rem; font-weight: 700; margin-top: 10px; }
.card-continent { font-size: 10px; letter-spacing: 2px; color: var(--gold); text-transform: uppercase; }

/* MODAL */
.modal-wrap { display: none; position: fixed; inset: 0; z-index: 9999; align-items: center; justify-content: center; padding: 20px; }
.modal-wrap.open { display: flex; }
.modal-backdrop { position: absolute; inset: 0; background: rgba(0,0,0,0.9); backdrop-filter: blur(15px); }
.modal {
  position: relative; width: 100%; max-width: 750px; background: var(--surface); border: 1px solid var(--gold); overflow-y: auto; max-height: 90vh;
}
.modal-header img { width: 100%; height: 250px; object-fit: cover; }
.modal-body { padding: 40px; }
.info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-top: 25px; }
.info-tile { background: var(--surface2); padding: 15px; border: 1px solid var(--border); }
.modal-close { position: absolute; top: 20px; right: 20px; font-size: 30px; color: white; cursor: pointer; background: none; border: none; }
</style>
</head>
<body>

<section class="hero">
  <div class="orb orb1"></div>
  <div class="orb orb2"></div>
  <div class="hero-eyebrow" style="color: var(--gold); letter-spacing: 4px; margin-bottom: 10px;">GLOBAL ATLAS</div>
  <h1 class="hero-title">Дэлхийн<br><strong>Улс Орнуудын</strong><br>Лавлах</h1>
  
  <div class="search-outer">
    <div class="search-inner">
      <span style="color: var(--gold);">🔍</span>
      <input id="searchInput" type="text" placeholder="Улс, нийслэл хайх..." autocomplete="off">
    </div>
  </div>
</section>

<main class="main">
  <div class="grid" id="grid"></div>
</main>

<div class="modal-wrap" id="modalWrap">
  <div class="modal-backdrop" onclick="closeModal()"></div>
  <div class="modal">
    <button class="modal-close" onclick="closeModal()">×</button>
    <div class="modal-header"><img id="mFlag" src=""></div>
    <div class="modal-body">
      <h2 id="mName" style="font-family: 'Cormorant Garamond', serif; font-size: 3rem; color: var(--gold);"></h2>
      <div id="mDesc" style="margin: 20px 0; color: var(--silver); line-height: 1.6;"></div>
      <div class="info-grid">
        <div class="info-tile"><div>НИЙСЛЭЛ</div><b id="mCap"></b></div>
        <div class="info-tile"><div>ХҮН АМ</div><b id="mPop"></b></div>
        <div class="info-tile"><div>ВАНЮТ</div><b id="mCur"></b></div>
        <div class="info-tile"><div>УТАСНЫ КОД</div><b id="mCall"></b></div>
      </div>
    </div>
  </div>
</div>

<script>
// 20+ УЛСЫН БОДИТ МЭДЭЭЛЛИЙГ ШУУД ОРУУЛАВ
const countries = [
  { name: "Монгол", code: "mn", capital: "Улаанбаатар", continent: "Ази", currency: "Төгрөг (MNT)", phone: "+976", pop: "3.4 сая", desc: "Дэлхийн хамгийн сийрэг хүн амтай, нүүдлийн соёл иргэншлээ хадгалсан үзэсгэлэнт тал нутаг." },
  { name: "Япон", code: "jp", capital: "Токио", continent: "Ази", currency: "Иен (JPY)", phone: "+81", pop: "125.7 сая", desc: "Технологийн өндөр хөгжил болон эртний соёл уламжлалыг төгс хослуулсан арлын улс." },
  { name: "АНУ", code: "us", capital: "Вашингтон", continent: "Америк", currency: "Доллар (USD)", phone: "+1", pop: "331.9 сая", desc: "Дэлхийн эдийн засаг, соёл, технологийн хамгийн том төвүүдийн нэг." },
  { name: "Герман", code: "de", capital: "Берлин", continent: "Европ", currency: "Евро (EUR)", phone: "+49", pop: "83.2 сая", desc: "Чанартай инженерчлэл, автомашин болон шар айрагны баялаг түүхтэй Европын зүрх." },
  { name: "БНХАУ", code: "cn", capital: "Бээжин", continent: "Ази", currency: "Юань (CNY)", phone: "+86", pop: "1.4 тэрбум", desc: "Эртний түүхтэй, дэлхийн хамгийн том үйлдвэрлэгч, хурдацтай хөгжиж буй гүрэн." },
  { name: "Франц", code: "fr", capital: "Парис", continent: "Европ", currency: "Евро (EUR)", phone: "+33", pop: "67.5 сая", desc: "Урлаг, соёл, загвар болон дэлхийн хамгийн тансаг хоолны өлгий нутаг." },
  { name: "Өмнөд Солонгос", code: "kr", capital: "Сөүл", continent: "Ази", currency: "Воно (KRW)", phone: "+82", pop: "51.7 сая", desc: "K-pop, орчин үеийн технологи болон хурдацтай дижитал шилжилтийн төв." },
  { name: "ОХУ", code: "ru", capital: "Москва", continent: "Европ/Ази", currency: "Рубль (RUB)", phone: "+7", pop: "144.1 сая", desc: "Дэлхийн хамгийн том газар нутагтай, байгалийн баялаг ихтэй гүрэн." },
  { name: "Итали", code: "it", capital: "Ром", continent: "Европ", currency: "Евро (EUR)", phone: "+39", pop: "59.1 сая", desc: "Сэргэн мандалтын үеийн түүх, пицца, паста болон Ferrari-ийн нутаг." },
  { name: "Их Британи", code: "gb", capital: "Лондон", continent: "Европ", currency: "Фунт (GBP)", phone: "+44", pop: "67.3 сая", desc: "Хаант засаглал, Биг Бен болон дэлхийн боловсролын тэргүүлэх төв." },
  { name: "Канад", code: "ca", capital: "Оттава", continent: "Америк", currency: "Доллар (CAD)", phone: "+1", pop: "38.2 сая", desc: "Нийтэч ард түмэн, үзэсгэлэнт байгаль болон мөсөн хоккейн эх орон." },
  { name: "Австрали", code: "au", capital: "Канберра", continent: "Далайн орнууд", currency: "Доллар (AUD)", phone: "+61", pop: "25.7 сая", desc: "Кенгуру, Сиднейн Дуурийн театр болон өвөрмөц ан амьтдын арал." },
  { name: "Энэтхэг", code: "in", capital: "Шинэ Дели", continent: "Ази", currency: "Рупи (INR)", phone: "+91", pop: "1.4 тэрбум", desc: "Дэлхийн хамгийн олон хүн амтай, баялаг соёл, халуун ногооны өлгий." },
  { name: "Бразил", code: "br", capital: "Бразилиа", continent: "Америк", currency: "Реал (BRL)", phone: "+55", pop: "214.3 сая", desc: "Карнавал, самба бүжиг болон хөлбөмбөгийн домогт улс." },
  { name: "Турк", code: "tr", capital: "Анкара", continent: "Европ/Ази", currency: "Лира (TRY)", phone: "+90", pop: "84.7 сая", desc: "Дорно болон Өрнийн соёл нэгдсэн, эртний түүхт Османы эзэнт гүрний залгамж." },
  { name: "Сингапур", code: "sg", capital: "Сингапур", continent: "Ази", currency: "Доллар (SGD)", phone: "+65", pop: "5.4 сая", desc: "Цэвэр цэмцгэр байдал, өндөр сахилга баттай Азийн санхүүгийн төв." },
  { name: "Швейцарь", code: "ch", capital: "Берн", continent: "Европ", currency: "Франк (CHF)", phone: "+41", pop: "8.7 сая", desc: "Альпийн нуруу, шоколад болон дэлхийн хамгийн аюулгүй банкны систем." },
  { name: "Арабын Нэгдсэн Эмират", code: "ae", capital: "Абу Даби", continent: "Ази", currency: "Дирхам (AED)", phone: "+971", pop: "9.3 сая", desc: "Дубай хот, Бурж Халифа болон цөлийн дундах орчин үеийн гайхамшиг." },
  { name: "Египет", code: "eg", capital: "Каир", continent: "Африк", currency: "Фунт (EGP)", phone: "+20", pop: "109.3 сая", desc: "Гизагийн пирамид, Нил мөрөн болон хүн төрөлхтний эртний соёл иргэншил." },
  { name: "Испани", code: "es", capital: "Мадрид", continent: "Европ", currency: "Евро (EUR)", phone: "+34", pop: "47.4 сая", desc: "Фламенко бүжиг, бухын тулаан болон нартай дулаан уур амьсгалаараа алдартай." }
];

function render(data) {
  const grid = document.getElementById('grid');
  grid.innerHTML = data.map(c => `
    <div class="card" onclick="openModal('${c.code}')">
      <img class="card-flag" src="https://flagcdn.com/w640/${c.code}.png">
      <div class="card-glass">
        <div>
          <div class="card-continent">${c.continent}</div>
          <div class="card-name">${c.name}</div>
          <div style="font-size:13px; color:var(--silver)">🏛 ${c.capital}</div>
        </div>
        <div style="font-size:10px; color:var(--gold); border-top:1px solid var(--border); padding-top:10px;">ДЭЛГЭРЭНГҮЙ ХАРАХ →</div>
      </div>
    </div>
  `).join('');
}

function openModal(code) {
  const c = countries.find(x => x.code === code);
  document.getElementById('mFlag').src = `https://flagcdn.com/w640/${c.code}.png`;
  document.getElementById('mName').textContent = c.name;
  document.getElementById('mDesc').textContent = c.desc;
  document.getElementById('mCap').textContent = c.capital;
  document.getElementById('mPop').textContent = c.pop;
  document.getElementById('mCur').textContent = c.currency;
  document.getElementById('mCall').textContent = c.phone;
  document.getElementById('modalWrap').classList.add('open');
  document.body.style.overflow = 'hidden';
}

function closeModal() {
  document.getElementById('modalWrap').classList.remove('open');
  document.body.style.overflow = '';
}

document.getElementById('searchInput').addEventListener('input', e => {
  const v = e.target.value.toLowerCase();
  render(countries.filter(c => c.name.toLowerCase().includes(v) || c.capital.toLowerCase().includes(v)));
});

render(countries);
</script>
</body>
</html>
