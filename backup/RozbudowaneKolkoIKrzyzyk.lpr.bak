program RozbudowaneKolkoIKrzyzyk;

uses CRT, Drzewo, ListaPodwojnieWiazana;

type planszaT = array of array of integer;
//Tablica jednowymiarowa
type tablicaJ = array[0..1] of integer;

////////////////////////////////////////////////////////////////////////////////
//Oznaczenia w tablicy zawierajacej stan gry:
//0 - pole puste; 1 - kolko; 2 - krzyzyk
////////////////////////////////////////////////////////////////////////////////


//Funkcja zmieniajaca stan planszy
function zmienP(plansza : planszaT; ruch : array of integer; ktoRuszyl : integer) : integer;
//var
begin
  plansza[ruch[0], ruch[1]] := ktoRuszyl;
end;

//Funkcja wypisujaca plansze
function wypiszP(plansza : planszaT; wymiar : integer) : integer;
var i1, i2 : integer;
begin
  //clrscr;
  for i1 := 0 to wymiar - 1 do
  begin
    for i2 := 0 to wymiar - 1 do
    begin
      if plansza[i1, i2] = 0 then Write('.   ')
        else if plansza[i1, i2] = 1 then Write('O   ')
          else Write('X   ');
    end;
    //Pzejscie do nowej lini:
    Writeln();
  end;
end;


//Funkcja sprawdzajaca same przekatne
//i, j - wspolzedne pocztaku przekatnej
//k = 1, (-1) - mowi, czy sprawdzamy na ukos od lewej do prawej, czy odwrotnie
function sprawdzPP(plansza : planszaT; wymiaryP : integer; iloscW : integer; i, j, k : integer) : integer;
var i1, i2 : integer;
begin
  sprawdzPP := 0;

  if k = 1 then
  begin
    //W zaleznosci ile 'iloscW' sie zmiesci w kolumnie
    for i1 := 0 to wymiaryP - iloscW - i - j do
    begin
      //Aby if w kolejnejnej petli for wykonal sie choc raz
      sprawdzPP := 4;

      //Sprawdzamy dwojkami
      for i2 := i1 to iloscW - 2 + i1 do
      begin
        if plansza[i + i2, j + i2] = plansza[i + i2 + 1, j + i2 + 1] then
        begin
          if sprawdzPP <> 0 then sprawdzPP := plansza[i + i1, j + i1];
        end else sprawdzPP := 0;
      end;
      if sprawdzPP <> 0 then Exit;
    end;
  end else
  begin
    //W zaleznosci ile 'iloscW' sie zmiesci w kolumnie
    for i1 := 0 to wymiaryP - iloscW - i - ((wymiaryP - 1) - j) do
    begin
      //Aby if w kolejnejnej petli for wykonal sie choc raz
      sprawdzPP := 4;

      //Sprawdzamy dwojkami
      for i2 := i1 to iloscW - 2 + i1 do
      begin
        //Writeln('[', i + i2, ', ', j - i2, ']  = [', i + i2 + 1, ', ', j - i2 - 1, ']   i2: ', i2);
        if plansza[i + i2, j - i2] = plansza[i + i2 + 1, j - i2 - 1] then
        begin
          if sprawdzPP <> 0 then sprawdzPP := plansza[i + i2, j - i2];
          //Writeln('    sprawdzPP ', sprawdzPP);
        end else sprawdzPP := 0;
      end;
      if sprawdzPP <> 0 then Exit;
    end;
  end;
end;

//Funkcja sprawdzajaca, cyz ktos wygral
//wymiaryP - wymiary planszy(obydwa sa takie same, wiec jedna zmienna);
//iloscW - ilosc wygrywajaca, czyli wymagana dlugosc ciagu takich zamych pol, by byla wygrana, minimalnie wynosi 2(!!!)
//Funkcja zwraca: 3 - gdy wystapi blad; 1,2 - w zaleznosci kto wygral, 0 - gdy sytuacja jest...
//...nierozstrzygnieta
function sprawdzP(plansza : planszaT; wymiaryP : integer; iloscW : integer) : integer;
var i1, i2, i3 : integer;
begin
  //Zerujemy na wszelki wypadek:
  sprawdzP := 0;

  //Gdy ktorys z parametrow sie nie zgadza, jest absurdalny itp. zwracamy blad
  if (wymiaryP < iloscW) or (iloscW < 2) then
  begin
    sprawdzP := 3; Exit;
  end
  else
  begin
    //Najpierw sprawdzamy POZIOME rozlozenie
    //Przesowamy sie po wierszach:
    for i1 := 0 to wymiaryP - 1 do
    begin
      //W danym wierszu sprawdzamy po iloscW pozycji na raz
      for i2 := 0 to wymiaryP - iloscW do
      begin
        //Tak, by za pierwszym razem warunek w warunku if w petli for ponizej sie wykonal:
        sprawdzP := 4;

        //Calosc rozbijamy jeszcze na dwa sprawdzenia
        for i3 := i2 to i2 + iloscW - 2 do
        begin
          //Writeln('[', i1, ', ', i3, ']  = [', i1, ', ', i3 + 1, ']   i2: ', i2);
          if (plansza[i1, i3] = plansza[i1, i3 + 1]) then
          begin
            if sprawdzP <> 0 then sprawdzP := plansza[i1, i3];
            //Writeln('\nsprawdzP ', sprawdzP);
          end else
            begin
              sprawdzP := 0;
            end;
        end;
        if sprawdzP <> 0 then Exit;
      end;
    end;
  end;

  //Nastepnie sprawdzamy PIONOWE rozlozenie
  for i1 := 0 to wymiaryP - 1 do
  begin
    for i2 := 0 to wymiaryP - iloscW do
    begin
      //Tak, by za pierwszym razem warunek w warunku if w petli for ponizej sie wykonal:
      sprawdzP := 4;

      for i3 := i2 to i2 + iloscW - 2 do
      begin
        if plansza[i3, i1] = plansza[i3 + 1, i1] then
        begin
          if sprawdzP <> 0 then sprawdzP := plansza[i3, i1];
        end else sprawdzP := 0;
      end;
      if sprawdzP <> 0 then Exit;
    end;
  end;

  //A na koncu UKOSNE rozlozenie
  //Najpierw sprawdzamy glowne przekatne
  sprawdzP := sprawdzPP(plansza, wymiaryP, iloscW, 0, 0, 1);
  if sprawdzP <> 0 then Exit;
  sprawdzP := sprawdzPP(plansza, wymiaryP, iloscW, 0, wymiaryP - 1, -1);
  if sprawdzP <> 0 then Exit;

  //Teraz szukamy takich przekatnych, ze sie w nich zmiesci iloscW kratek:
  //Najpierw te od [0, 1] -> [0, k]...
  //...i te od [1, 0] -> [k, 0]
  //Potem te od [0, n-1] -> [0, k]...
  //...i te od [1, n] -> [k, n]
  for i1 := 0 to wymiaryP - iloscW - 1 do
  begin
    sprawdzP := sprawdzPP(plansza, wymiaryP, iloscW, 0, i1 + 1, 1);
    if sprawdzP <> 0 then Exit;

    sprawdzP := sprawdzPP(plansza, wymiaryP, iloscW, i1 + 1, 0, 1);
    if sprawdzP <> 0 then Exit;

    sprawdzP := sprawdzPP(plansza, wymiaryP, iloscW, 0, wymiaryP - 2 - i1, -1);
    if sprawdzP <> 0 then Exit;

    sprawdzP := sprawdzPP(plansza, wymiaryP, iloscW, i1 + 1, wymiaryP - 1, -1);
    if sprawdzP <> 0 then Exit;
  end;
end;


//Funkcja sprawdzajaca, czy w totczeniu podanego punktu znajduja sie inne punkty
//'punktP' - punkt na planszy
//Zwracane wartosci: 1 - otoczenie istnieje; 0 - otoczenie nie istnieje
function szukajOtoczenia(plansza : planszaT; punktP : array of integer; wymiaryP : integer) : integer;
var i1, i2 : integer; b1, b2, b3, b4 : boolean;
begin
  //Na poczatku inicjalizujemy zwracana wartosc
  szukajOtoczenia := 0;

  //Wartosci te beda sprawdzane wielokrotnie, wiec kosztem narzutu pamieci optymalizujemy kod pod wzgledem czasu wykonania
  //Czy istnieja elementy powyzej danego elementu
  b1 := (punktP[0] <> 0);
  //Czy istnieja elementy ponizej
  b2 := (punktP[0] < wymiaryP - 1);
  //Czy istnieja elementy z lewej strony
  b3 := (punktP[1] <> 0);
  //Czy istnieja elementy z prawej strony
  b4 := (punktP[1] < wymiaryP - 1);

  //Zaczynamy od elementu znajdujacego sie w lewym, gornym rogu - poruszamy sie zgodnie ze wskazowkami zegara
  //Sprawdzamy przylegle punkty powyzej
  if b1 and b3 then if (plansza[punktP[0] - 1, punktP[1] - 1]) <> 0 then begin szukajOtoczenia := 1; exit; end;
  if b1 then if (plansza[punktP[0] - 1, punktP[1]]) <> 0 then begin szukajOtoczenia := 1; exit; end;
  if b1 and b4 then if (plansza[punktP[0] - 1, punktP[1] + 1]) <> 0 then begin szukajOtoczenia := 1; exit; end;

  if b4 then if (plansza[punktP[0], punktP[1] + 1]) <> 0 then begin szukajOtoczenia := 1; exit; end;

  //Sprawdzamy pnkty przylegle ponizej
  if b2 and b4 then if (plansza[punktP[0] + 1, punktP[1] + 1]) <> 0 then begin szukajOtoczenia := 1; exit; end;
  if b2 then if (plansza[punktP[0] + 1, punktP[1]]) <> 0 then begin szukajOtoczenia := 1; exit; end;
  if b2 and b3 then if (plansza[punktP[0] + 1, punktP[1] - 1]) <> 0 then begin szukajOtoczenia := 1; exit; end;

  if b3 then if (plansza[punktP[0], punktP[1] - 1]) <> 0 then begin szukajOtoczenia := 1; exit; end;
end;

//Funkcja sprawdzajaca mozliwe ruchy - podaje jeden wedlug ustalonego schematu
//Schemat:
//W pierwszej kolejnosci sprawdzane sa pola w ktorych najblisze sasiedztwo - tj.
//stykajace sie pola - nie sa puste
function szukajRuchu(plansza : planszaT; ostatni : array of integer; wymiaryP : integer) : tablicaJ;
//tablica 'rezultat' zostala utworzona by funkcja mogla przekazac wynik, a tablica 'pomocnicza' by...
//...moc przekazywac argumenty do funkcji 'szukajOtocznia'
var i1, i2 : integer; rezultat, pomocnicza : array[0..1] of integer;
begin
  //Jesli podany punkt znajduje sie poza tablica, to zwracamy blad czyli [-1, -1]
  //UWAGA nie uwzgledniamy wartosci ujemnych!!!
  if (ostatni[0] >= wymiaryP) or (ostatni[1] >= wymiaryP) then
  begin
    rezultat[0] := -1; rezultat[1] := -1;
    szukajRuchu := rezultat;
    exit;
  end;

  //Jesli jako ostatni zostal przekazany element o wspolzednych ujemnych to szukamy od pierwszego elementu,...
  //...a tym poza glowna petla musimy sprawdzic, czy pierwszy element nam odpowiada, jesli tak to konczymy sprawdzanie,...
  //...a jesli nie, to kontynujemy
  pomocnicza[0] := 0; pomocnicza[1] := 0;
  if (ostatni[0] < 0) or (ostatni[1] < 0) then
  begin
    if (szukajOtoczenia(plansza, pomocnicza, wymiaryP) = 1) and (plansza[pomocnicza[0], pomocnicza[1]] = 0) then
    begin
      rezultat[0] := 0; rezultat[1] := 0;
      szukajRuchu := rezultat;
      exit;
    end;
    //Po tej instrukcji if sprawdzamy dla wszystkich poza elementem [0, 0], ktory juz sprawdzilismy
    ostatni[0] := 0; ostatni[1] := 0;
  end;

  //Na poczatek jako zwracany element ustawiamy na element spoza planszy, na wypadek...
  //...gdybysmy nie znalexli takiego, ktoryby spelanial warunki, jest to rozumiane jako zwracanie bledu przez te funkcje
  rezultat[0] := -1; rezultat[1] := -1;
  szukajRuchu := rezultat;

  //Szukamy od wiersza, w ktorym znajduje sie ostatnio znaleziony element
  for i1 := ostatni[0] to wymiaryP - 1 do
  begin
    for i2 := 0 to wymiaryP - 1 do
    begin
      //Sprawdzamy, czy przypadkiem [i1, i2] nie wskazuje na element będący przed elementem 'ostatni', lub...
      //...na element 'ostatni':
      if not((i1 = ostatni[0]) and (i2 <= ostatni[1])) then
      begin
        pomocnicza[0] := i1; pomocnicza[1] := i2;
        //Do sprawdzenia:
        //Writeln('pomocnicza[0] := ', pomocnicza[0], '   pomocnicza[1] := ', pomocnicza[1]);
        if (szukajOtoczenia(plansza, pomocnicza, wymiaryP) = 1) and (plansza[pomocnicza[0], pomocnicza[1]] = 0) then
        begin
          //Write('Tutaj2   ');
          szukajRuchu := pomocnicza;
          exit;
        end;
      end;
    end;
  end;
end;



{//Funkcja do zarzadzania grafem
function ZarzadzajG(korzen : WezelP) : integer;
var ostatni : array[0..1] of integer;
begin
  if korzen = NIL then korzen := dodajW();

end;}


//Funkcja usuwajaca z grafu niepotrzebne elementy po wykonanych ruchach:




//Funkcja uzupelniajaca drzewo w podwezly - bedzie rekurencyjna(prawdopodobnie spowoduje to duzy narzut pamieci)
//Opis zmiennych pobieranych przez funkcje:
//'plansza' - plansza gry; 'wymiaryP' - wymiary tej planszy; 'wezel' - wskaznik do naszego wezla; 'stopienZ' - stopien zagniezdzenia...
//...; 'kogoRuch' - mowi, kto ma teraz ruch; 'docelowySZ' - stopien zagniezdzenia, po ktorego osiagnieciu nie szukamy dalszych podwezlow...
//...; 'iloscW' - wymagana ilosc takich samych "piokow" w lini, by wygrac, potrzebne do ocenienia, czy wezel jest wygrywajacy
function UzupelnijG(plansza : planszaT; wymiaryP : integer; wezel : WezelP; stopienZ : integer; kogoRuch : integer; docelowySZ, iloscW, kimNieGramy : integer) : integer;
//'stopienZ' - stopien zagniezdzenia
var i1, czyWygrywajacy, kogoNastepnyRuch : integer; ruch : array[0..1] of integer; nowyWezel : WezelP;
begin
  i1 := 0;
  //Szukamy od poczatku planszy:
  ruch[0] := -1; ruch[1] := -1;

  if kogoRuch = 1 then kogoNastepnyRuch := 2 else kogoNastepnyRuch := 1;

  while i1 <> -1 do
  begin
    //szukajRuchu(plansza : planszaT; ostatni : array of integer; wymiaryP : integer) : tablicaJ;
    //Write('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1], ';     ');
    ruch := szukajRuchu(plansza, ruch, wymiaryP);
    //Writeln('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1]);
    if (ruch[0] <> -1) and (ruch[1] <> -1) then
    begin
      //function dodajPW(wezel : WezelP; Nr : integer) : WezelP;
      nowyWezel := dodajPW(wezel, i1);
      //Zmieniamy plansze
      zmienP(plansza, ruch, kogoRuch);
      czyWygrywajacy := SprawdzP(plansza, wymiaryP, iloscW);

      //if czyWygrywajacy <> 0 then Writeln(czyWygrywajacy);
      //function inicjalizujDG(wezel : WezelP; stopien : integer; wartosc : integer; ruch : array of integer; kogoRuch : integer) : integer;
      inicjalizujDG(nowyWezel, stopienZ, czyWygrywajacy, ruch, kogoRuch);
      //Writeln('!!!!!!ruch[0] := ', [0], '   ruch[1] := ', ruch[1]);
      //Jesli oczekuje sie wiekszego zagniezdzenia wezlow szukamy podwezlow dla nowo znalezionego wezla:
      if (stopienZ < docelowySZ) and (czyWygrywajacy = 0) then
      begin
        UzupelnijG(plansza, wymiaryP, nowyWezel, stopienZ + 1, kogoNastepnyRuch, docelowySZ, iloscW, kimNieGramy);
      end;
      //Spowrotem zmieniamy plansze:
      zmienP(plansza, ruch, 0);
      //wypiszP(plansza, wymiaryP);
      //Writeln();

      i1 := i1 + 1;

      //Jesli ruch jest wygrywajacy dla przeciwnika, to nie szukamy juz dalszych podwezlow, bo uzytkownik napewno wybierze ten,...
      //...najgorszy dla nas wiec dalsze sprawdzanie nie ma sensu
      if czyWygrywajacy = kimNieGramy then i1 := -1;

    end else
    begin
      i1 := -1;
      exit;
    end;
  end;
end;


//Funkcja zliczajaca ilosc wezlow wygrywajacych dla danego gracza w sciezkach wychodzacych z danego wezla
function iloscWW(wezel : WezelP; dlaGracza : integer) : integer;
//'podwezel' - wskaznik pomocniczy;
var podwezel : ElementP;
begin
  //'podwezel' zaczyna wskazywac na pierwszy podwezel
  podwezel := wezel^.Podwezly;
  //Poczatkowe ustawienie wartosci
  iloscWW := 0;

  //Jesli ten wezel jest wygrywajacy, to
  if wezel^.DaneP^.Wartosc = dlaGracza then
  begin
    iloscWW := 1 * (9999999 - 1000* wezel^.DaneP^.Stopien);
    //Wezel ten jest wygrywajacy, wiec nie ma podwezlow, dlatego wychodzimy z funkcji:
    exit;
  end;

  while podwezel <> NIL do
  begin
    iloscWW := iloscWW + iloscWW(podwezel^.Wezel, dlaGracza);
    //Przesowamy wskaznik
    podwezel := podwezel^.Nast;
  end;
end;

//Funkcja szukajaca najlepszej scierzki w drzewie - rekurencja
//'dlaGracza' - zmienna z wartoscia, ktora mowi, dla kogo ma byc szukana wygrana, czyli z kim "trzyma" algorytm
function najlepszaS(wezel : WezelP; dlaGracza : integer) : WezelP;
//'podwezel' - wskaznik pomocniczy; 'ostatniaW' - zmienna przechowujaca ilosc wezlow wygrywajacych dla...
//... najlepszego wezla znalezionego do tej pory, a zmienna 'nowaW' to samo, tylko dla nowo wyszukanego wezla - przechowywana, by moc je porownac
var podwezel : ElementP; ostatniaW, nowaW, dlaPrzeciwnika : integer;
begin
  if dlaGracza = 1 then dlaPrzeciwnika := 2 else dlaPrzeciwnika := 1;
  //'podwezel' zaczyna wskazywac na pierwszy podwezel
  podwezel := wezel^.Podwezly;

  //Na poczatek ustawiamy wskaxnik na pierwszym elemencie:
  najlepszaS := podwezel^.Wezel;
  ostatniaW := 99999999;

  while podwezel <> NIL do
  begin
    //Jesli dany podwezel ma wiecej wezlow wygrywajacych "pod soba" to zmieniamy wskaxniki
    //Najpierws sprawdzamy ilosc wezlow wygrywajacych dla kolejnego podwezla
    nowaW := iloscWW(podwezel^.Wezel, dlaPrzeciwnika);
    //sprawdzamy, czy jest wieksza
    if nowaW < ostatniaW then
    begin
      //jesli tak, to zamieniamy wskazniki
      najlepszaS := podwezel^.Wezel;
      //i mieniamy stan zm. 'ostatniaW', ktora zamwsz mowi o ilosc wezlow wygrywajacych dla wezla na ktory wskazuje 'najlpeszaS'
      ostatniaW := nowaW;
    end;

    //Writeln(ostatniaW);

    //Przesowamy wskaznik
    podwezel := podwezel^.Nast;
  end;
end;







//Funkcja dodajaca podwezly i sprawdzajaca, czy ktorys jest wygrywajacy - bedzie rekurencyjna(prawdopodobnie spowoduje to duzy narzut pamieci)
//Opis zmiennych pobieranych przez funkcje:
//'plansza' - plansza gry; 'wymiaryP' - wymiary tej planszy; 'wezel' - wskaznik do naszego wezla; 'stopienZ' - stopien zagniezdzenia...
//...; 'kogoRuch' - mowi, kto ma teraz ruch; 'docelowySZ' - stopien zagniezdzenia, po ktorego osiagnieciu nie szukamy dalszych podwezlow...
//...; 'iloscW' - wymagana ilosc takich samych "piokow" w lini, by wygrac, potrzebne do ocenienia, czy wezel jest wygrywajacy
function SzukajRwP(plansza : planszaT; wymiaryP : integer; wezel : WezelP; stopienZ : integer; kogoRuch : integer; iloscW : integer) : WezelP;
//'stopienZ' - stopien zagniezdzenia
var i1, czyWygrywajacy, kogoNastepnyRuch : integer; ruch : array[0..1] of integer; nowyWezel : WezelP;
begin
  i1 := 1;
  //Szukamy od poczatku planszy:
  ruch[0] := -1; ruch[1] := -1;

  //if kogoRuch = 1 then kogoNastepnyRuch := 2 else kogoNastepnyRuch := 1;

  while i1 <> -1 do
  begin
    //szukajRuchu(plansza : planszaT; ostatni : array of integer; wymiaryP : integer) : tablicaJ;
    //Write('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1], ';     ');
    ruch := szukajRuchu(plansza, ruch, wymiaryP);
    //Writeln('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1]);
    if (ruch[0] <> -1) and (ruch[1] <> -1) then
    begin
      //function dodajPW(wezel : WezelP; Nr : integer) : WezelP;
      nowyWezel := dodajPW(wezel, i1);
      //Zmieniamy plansze
      zmienP(plansza, ruch, kogoRuch);
      czyWygrywajacy := SprawdzP(plansza, wymiaryP, iloscW);

      //if czyWygrywajacy <> 0 then Writeln(czyWygrywajacy);
      //function inicjalizujDG(wezel : WezelP; stopien : integer; wartosc : integer; ruch : array of integer; kogoRuch : integer) : integer;
      inicjalizujDG(nowyWezel, stopienZ, czyWygrywajacy, ruch, kogoRuch);
      //Writeln('!!!!!!ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1]);
      //Jesli oczekuje sie wiekszego zagniezdzenia wezlow szukamy podwezlow dla nowo znalezionego wezla:
      {
      if (stopienZ < docelowySZ) and (czyWygrywajacy = 0) then
      begin
        UzupelnijG(plansza, wymiaryP, nowyWezel, stopienZ + 1, kogoNastepnyRuch, docelowySZ, iloscW, kimNieGramy);
      end;
      }
      //Spowrotem zmieniamy plansze:
      zmienP(plansza, ruch, 0);
      //wypiszP(plansza, wymiaryP);
      //Writeln();

      i1 := i1 + 1;

      //Jesli ruch jest wygrywajacy dla ktoregos z graczy, to nie szukamy juz dalszych podwezlow, bo wybieramy wlasnie ten
      if czyWygrywajacy <> 0 then
      begin
        i1 := -1;
        szukajRwP := nowyWezel;
      end;

    end else
    begin
      i1 := -1;
      szukajRwP := NIL;
      exit;
    end;
  end;
end;

//Funkcja szukajaca ................... - bedzie rekurencyjna(prawdopodobnie spowoduje to duzy narzut pamieci)
//Opis zmiennych pobieranych przez funkcje:
//'plansza' - plansza gry; 'wymiaryP' - wymiary tej planszy; 'wezel' - wskaznik do naszego wezla; 'stopienZ' - stopien zagniezdzenia...
//...; 'kogoRuch' - mowi, kto ma teraz ruch; 'docelowySZ' - stopien zagniezdzenia, po ktorego osiagnieciu nie szukamy dalszych podwezlow...
//...; 'iloscW' - wymagana ilosc takich samych "piokow" w lini, by wygrac, potrzebne do ocenienia, czy wezel jest wygrywajacy
function SzukajWR(plansza : planszaT; wymiaryP, iloscW, kimGramy : integer; wezel : WezelP) : TablicaJ;
//'stopienZ' - stopien zagniezdzenia
var kogoNastepnyRuch : integer; ruch : array[0..1] of integer; nowyWezel : WezelP; pomE : ElementP;
begin
  if wezel^.DaneP^.KogoRuch = 1 then kogoNastepnyRuch := 2 else kogoNastepnyRuch := 1;
  ruch[0] := -1; ruch[1] := -1;

  //Sprawdzamy, czy dany wezel ma jakies podwezly:
  if wezel^.Podwezly = NIL then
  begin
    //SzukajRwP(plansza : planszaT; wymiaryP : integer; wezel : WezelP; stopienZ : integer; kogoRuch : integer; iloscW : integer) : WezelP;
    nowyWezel := SzukajRwP(plansza, wymiaryP, wezel, wezel^.DaneP^.Stopien + 1, kogoNastepnyRuch, iloscW);
    if nowyWezel <> NIL then
    begin
      SzukajWR := nowyWezel^.DaneP^.Ruch;
    end else
    begin
      SzukajWR := ruch;
      //Writeln('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1]);
    end;
  end else
  begin
    pomE := wezel^.Podwezly;
    while pomE <> NIL do
    begin
      SzukajWR(plansza, wymiaryP, iloscW, kimGramy, pomE^.Wezel);
      pomE := pomE^.Nast;
    end;
  end;
end;

//Funkcja szukajaca najlepszego ruchu - bedzie rekurencyjna(prawdopodobnie spowoduje to duzy narzut pamieci)
//Opis zmiennych pobieranych przez funkcje:
//'plansza' - plansza gry; 'wymiaryP' - wymiary tej planszy; 'wezel' - wskaznik do naszego wezla; 'stopienZ' - stopien zagniezdzenia...
//...; 'kogoRuch' - mowi, kto ma teraz ruch; 'docelowySZ' - stopien zagniezdzenia, po ktorego osiagnieciu nie szukamy dalszych podwezlow...
//...; 'iloscW' - wymagana ilosc takich samych "piokow" w lini, by wygrac, potrzebne do ocenienia, czy wezel jest wygrywajacy
function SzukajR(plansza : planszaT; wymiaryP : integer; docelowySZ, iloscW, kimGramy : integer) : TablicaJ;
//'stopienZ' - stopien zagniezdzenia
var i1, i2, i3, czyWygrywajacy, kogoNastepnyRuch, stopienZ : integer; ruch : array[0..1] of integer; korzen, nowyWezel, pomW: WezelP; pomE : ElementP;
begin
  korzen := dodajW();
  korzen^.Nr := 0;

  {ruch[0] := -1; ruch[1] := -1;}

  inicjalizujDG(korzen, 0, 0, ruch, kimGramy);

  i1 := 0;

  //SzukajWR(plansza : planszaT; wymiaryP, iloscW, kimGramy : integer, wezel : WezelP) : TablicaJ;
  while i1 < docelowySZ do
  begin
    ruch := SzukajWR(plansza, wymiaryP, iloscW, kimGramy, korzen);
    if (ruch[0] <> -1) and (ruch[1] <> -1) then
    begin
      i1 := docelowySZ;
      Writeln('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1]);
    end;
    i1 := i1 + 1;
    Writeln('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1]);
  end;

  if (ruch[0] <> -1) and (ruch[1] <> -1) then
  begin
    SzukajR := ruch;
  end else
  begin
    SzukajR := szukajRuchu(plansza, ruch, wymiaryP);
  end;
  //Writeln('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1]);

  //i1 := 1 bo dla pierwszego stopnia sprawdzamy poza glowana petla
  {i1 := 1;
  stopienZ := 0;

  if kogoRuch = 1 then kogoNastepnyRuch := 2 else kogoNastepnyRuch := 1;}

  //Najpierwsz szukamy dla pierwszego ruchu
  //SzukajRwP(plansza : planszaT; wymiaryP : integer; wezel : WezelP; stopienZ : integer; kogoRuch : integer; iloscW : integer) : WezelP;
  //nowyWezel := szukajRwP(plansza, wymiaryP, korzen, stopienZ + 1, kogoNastepnyRuch, iloscW);

  {//Pozniej szukamy dla drugiego i kolejnych
  if nowyWezel = NIL then
  begin
    while i1 < docelowySZ do
    begin

       pomE := korzen^.Podwezly
       while pomE <> NIL do
       begin
         i2 := 0;
         while i2 < i1 do
         begin
           pomE := pomE^.Wezel^.Podwezly;

           pomE := pomE^.Nast;

           while
           begin

           end;
         end;
         pomE := pomE^.Nast;
       end;
    end;
  end else
  begin
    szukajR := nowyWezel^.DaneP^.Ruch;
  end;

  end;}


  {while i1 <> -1 do
  begin
    //szukajRuchu(plansza : planszaT; ostatni : array of integer; wymiaryP : integer) : tablicaJ;
    //Write('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1], ';     ');
    ruch := szukajRuchu(plansza, ruch, wymiaryP);
    //Writeln('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1]);
    if (ruch[0] <> -1) and (ruch[1] <> -1) then
    begin
      //function dodajPW(wezel : WezelP; Nr : integer) : WezelP;
      nowyWezel := dodajPW(wezel, i1);
      //Zmieniamy plansze
      zmienP(plansza, ruch, kogoRuch);
      czyWygrywajacy := SprawdzP(plansza, wymiaryP, iloscW);

      //if czyWygrywajacy <> 0 then Writeln(czyWygrywajacy);
      //function inicjalizujDG(wezel : WezelP; stopien : integer; wartosc : integer; ruch : array of integer; kogoRuch : integer) : integer;
      inicjalizujDG(nowyWezel, stopienZ, czyWygrywajacy, ruch, kogoRuch);
      //Writeln('!!!!!!ruch[0] := ', [0], '   ruch[1] := ', ruch[1]);
      //Jesli oczekuje sie wiekszego zagniezdzenia wezlow szukamy podwezlow dla nowo znalezionego wezla:
      if (stopienZ < docelowySZ) and (czyWygrywajacy = 0) then
      begin
        UzupelnijG(plansza, wymiaryP, nowyWezel, stopienZ + 1, kogoNastepnyRuch, docelowySZ, iloscW, kimNieGramy);
      end;
      //Spowrotem zmieniamy plansze:
      zmienP(plansza, ruch, 0);
      //wypiszP(plansza, wymiaryP);
      //Writeln();

      i1 := i1 + 1;

      //Jesli ruch jest wygrywajacy dla przeciwnika, to nie szukamy juz dalszych podwezlow, bo uzytkownik napewno wybierze ten,...
      //...najgorszy dla nas wiec dalsze sprawdzanie nie ma sensu
      if czyWygrywajacy = kimNieGramy then i1 := -1;

    end else
    begin
      i1 := -1;
      exit;
    end;
  end;}
end;




















//Funkcja sprawdzajaca, czy przy danym stanie gry dany ruch jest dozwolony




//Zmienne globalne:
var
  //Wymiar planszy, k - sterowaniem przebiegiem petli, l - ilosc potrzebnych tych samych znakow w lini by ktos wygral:
  //m - zmienna pomocnicza
  n, k, l, m: integer;
  //Zmienna do przechowywania, wartosci mowiacej o tym, kogo jest obecnie ruch
  b : integer;
  //Zmienna na przechowywanie dycyzji gracza o jego ruchu:
  ruch, ruch1 : array[0..1] of integer;
  //Korzen drzewa - globalnie bo nie chcemy po kazdym ruchu ktorego z graczy tworzyc go od nowa
  //'najlepszyRuch' - zmienna najprawdopodobniej tymczasowa:
  korzen, najlepszyRuch : WezelP;
  //Tablica na przechowywanie stanu gry:
  plansza : planszaT;


begin
  Writeln('Jakis tekst');
  n := 10;
  Setlength(plansza, n, n);

  korzen := dodajW();

  l := 5;
  m := 3;
  //Zmienna 'k' do sterowaniu przebiegiem petli while
  k := 16;

  b := 1;

  while k <> 0 do
  begin
    wypiszP(plansza, n);
    Writeln('Wygral ', SprawdzP(plansza, n, l));
    ruch[0] := 0; ruch[1] := 0;
    //Writeln('Szukamy ruchu: ', (szukajRuchu(plansza, ruch, n))[0], '  ', (szukajRuchu(plansza, ruch, n))[1]);
    Write('Podaj jaki ruch chcesz wykonac: ');
    Read(ruch[0], ruch[1]);
    zmienP(plansza, ruch, b);

    //UzupelnijG(plansza : planszaT; wymiaryP : integer; wezel : WezelP; stopienZ : integer; kogoRuch : integer; docelowySZ, iloscW, kimNieGramy : integer) : integer;
      UzupelnijG(plansza, n, korzen, 0, 3, 2, m, 1);
      //wypiszW(korzen);

      if k = 16 - 4 then m := l;
      najlepszyRuch := najlepszaS(korzen, 2);
      //Writeln('Najlepszy ruch dla O to: ', najlepszyRuch^.DaneP^.Ruch[0], ', ', najlepszyRuch^.DaneP^.Ruch[1]);
      ruch[0] := najlepszyRuch^.DaneP^.Ruch[0]; ruch[1] := najlepszyRuch^.DaneP^.Ruch[1];

      //SzukajR(plansza : planszaT; wymiaryP : integer; docelowySZ, iloscW, kimGramy : integer) : TablicaJ;
      ruch1 := SzukajR(plansza, n, 4, l, 2);
      Writeln('Najlepszy ruch dla X to: ', ruch1[0], ', ', ruch1[1]);
      zmienP(plansza, ruch, 2);
      usunW(korzen);
      korzen := dodajW();

    {if b = 1 then b := 2 else b:= 1;

    if b = 2 then
    begin
      //UzupelnijG(plansza : planszaT; wymiaryP : integer; wezel : WezelP; stopienZ : integer; kogoRuch : integer; docelowySZ, iloscW, kimNieGramy : integer) : integer;
      UzupelnijG(plansza, n, korzen, 0, 2, 4, l, 1);
      //wypiszW(korzen);

      najlepszyRuch := najlepszaS(korzen, 2);
      Writeln('Najlepszy ruch dla O to: ', najlepszyRuch^.DaneP^.Ruch[0], ', ', najlepszyRuch^.DaneP^.Ruch[1]);

      usunW(korzen);
      korzen := dodajW();
    end;}

    k := k - 1;
  end;
  wypiszW(korzen);
  Read(k);
end.




















