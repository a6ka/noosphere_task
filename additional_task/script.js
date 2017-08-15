//Число от 0 до 9999 записать прописью
var thousend=hundred=ten=element=0, 
	num, 
	ten2str=element2str=""
	;
var thousendArr = ['', 'одна тысяча ', 'две тысячи ', 'три тысячи ', 'четыре тысячи ', 'пять тысячь ', 'шесть тысячь ', 'семь тысячь ', 'восемь тысячь ', 'девять тысячь '];
var hundredArr = ['', 'сто ', 'двести ', 'триста ', 'четыреста ', 'пятьсот ', 'шестьсот ', 'семьсот ', 'восемьсот ', 'девятьсот '];
var tenArr = ['', 'десять', 'двадцать ', 'тридцать ', 'сорок ', 'пятьдесят ', 'шестьдесят ', 'семьдесят ', 'восемьдесят ', 'девяносто '];
var tenUniqueArr = ['десять', 'одиннадцать', 'двенадцать', 'тринадцать', 'четырнадцать', 'пятнадцать', 'шестнадцать', 'семнадцать', 'восемнадцать', 'девятнадцать'];
var elementArr = ['', 'один', 'два', 'три', 'четыре', 'пять', 'шесть', 'семь', 'восемь', 'девять'];
num=+prompt("Введите число от 0 до 9999:");
//Проверяем: число от 0 до 9999, число целое
if(num>0&&num<10000&&num%1===0){
	element=num%10;
	num-=element;
	num/=10;
	ten=num%10;
	num-=ten;
	num/=10;
	hundred=num%10;
	num-=hundred;
	num/=10;
	thousend=num%10;
	//Переименовываем единицы, при отсутствии десятков
	element2str = elementArr[element];
	if(ten === 1) {
		ten2str = tenUniqueArr[element];
		element2str = '';
	} else {
		ten2str = tenArr[ten];
	}

	alert(thousendArr[thousend]+hundredArr[hundred]+ten2str+element2str);
} else if(num === 0) {
	alert("ноль");
} else {
	alert("error");
} 