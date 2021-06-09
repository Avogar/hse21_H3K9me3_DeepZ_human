# Проект по биоинформатике 

Организм: human.

Структура ДНК: ZDNA_DeepZ.

Гистоновая метка: H3K9me3.

Тип клеток: MCF-7.

Chip-seq эксперименты: https://www.encodeproject.org/files/ENCFF501UHK/, https://www.encodeproject.org/files/ENCFF518MOR/

## 0. Скачивание данных.

Скачиваем данные экспериментов командами:
```bash
wget https://www.encodeproject.org/files/ENCFF501UHK/@@download/ENCFF501UHK.bed.gz
wget https://www.encodeproject.org/files/ENCFF518MOR/@@download/ENCFF518MOR.bed.gz
```

Оставим только первые 5 столбцов:
```bash
zcat ENCFF501UHK.bed.gz | cut -f1-5 > H3K9me3_MCF7.ENCFF501UHK.hg38.bed
zcat ENCFF518MOR.bed.gz | cut -f1-5 > H3K9me3_MCF7.ENCFF518MOR.hg38.bed
```

Приведем данные из версии hg38 к версии hg19 командами:
```bash
wget https://hgdownload.cse.ucsc.edu/goldenpath/hg38/liftOver/hg38ToHg19.over.chain.gz
liftOver H3K9me3_MCF7.ENCFF518MOR.hg38.bed  hg38ToHg19.over.chain.gz   H3K9me3_MCF7.ENCFF518MOR.hg19.bed   H3K9me3_MCF7.ENCFF518MOR.unmapped.bed 
liftOver H3K9me3_MCF7.ENCFF501UHK.hg38.bed  hg38ToHg19.over.chain.gz   H3K9me3_MCF7.ENCFF501UHK.hg19.bed   H3K9me3_MCF7.ENCFF501UHK.unmapped.bed
```

## 1. Анализ пиков гистоновой метки

Построим гистограммы длин участков для каждого эксперимента до и после конвертации из верси hg38 в hg19, используя программу [len_hist.R](https://github.com/Avogar/hse21_H3K9me3_DeepZ_human/blob/master/src/len_hist.R)

- Эксперимент ENCFF501UHK, версия hg38, количество пиков 40646: 

<img src="/images/len_hist.H3K9me3_MCF7.ENCFF501UHK.hg38.png" alt="H3K9me3_MCF7.ENCFF501UHK.hg38" width="600"/>

- Эксперимент ENCFF501UHK, версия hg19, количество пиков 40249: 

<img src="/images/len_hist.H3K9me3_MCF7.ENCFF501UHK.hg19.png" alt="H3K9me3_MCF7.ENCFF501UHK.hg19" width="600"/>

- Эксперимент ENCFF518MOR, версия hg38, количество пиков 39779: 

<img src="/images/len_hist.H3K9me3_MCF7.ENCFF518MOR.hg38.png" alt="H3K9me3_MCF7.ENCFF518MOR.hg38" width="600"/>

- Эксперимент ENCFF518MOR, версия hg19, количество пиков 39216: 

<img src="/images/len_hist.H3K9me3_MCF7.ENCFF518MOR.hg19.png" alt="H3K9me3_MCF7.ENCFF518MOR.hg19" width="600"/>

Выкинем слишком длинные пики (>5000), используя программу используя программу [filter_peaks.R](https://github.com/Avogar/hse21_H3K9me3_DeepZ_human/blob/master/src/filter_peaks.R), и построим гистограммы после фильтрации для данных hg19

- Эксперимент ENCFF501UHK, количество пиков 40166: 

<img src="/images/filter_peaks.H3K9me3_MCF7.ENCFF501UHK.hg19.filtered.hist.png" alt="H3K9me3_MCF7.ENCFF501UHK.hg19" width="600"/>

- Эксперимент ENCFF518MOR, количество пиков 39189: 

<img src="/images/filter_peaks.H3K9me3_MCF7.ENCFF518MOR.hg19.filtered.hist.png" alt="H3K9me3_MCF7.ENCFF518MOR.hg19" width="600"/>

Посмотрим, где располагаются пики гистоновой метки относительно аннотированных генов. Для этого построим графики типа пай-чарт, используя программу [chip_seeker.R](https://github.com/Avogar/hse21_H3K9me3_DeepZ_human/blob/master/src/chip_seeker.R).

- Эксперимент ENCFF501UHK:

<img src="/images/chip_seeker.H3K9me3_MCF7.ENCFF501UHK.hg19.filtered.plotAnnoPie.png" alt="H3K9me3_MCF7.ENCFF501UHK.hg19" width="500"/>

- Эксперимент ENCFF518MOR:

<img src="/images/chip_seeker.H3K9me3_MCF7.ENCFF518MOR.hg19.filtered.plotAnnoPie.png" alt="H3K9me3_MCF7.ENCFF518MOR.hg19" width="500"/>

Объединим данные двух экспериментов командой:
```bash
cat  *.filtered.bed | sort -k1,1 -k2,2n | bedtools merge > H3K9me3_MCF7.merge.hg19.bed
```

Визуализируем исходные два набора ChIP-seq пиков, а также их объединение в геномном браузере. Ссылка на сессию в геномном браузере будет далее в отчете.

## 2. Анализ участков вторичной стр-ры ДНК

Построим гистограмму распределения длин участков вторичной стр-ры ДНК. Количество пиков 19394:

<img src="/images/len_hist.DeepZ.png" alt="DeepZ" width="600"/>

Посмотрим, где располагаются участки стр-ры ДНК относительно аннотированных генов:

<img src="/images/chip_seeker.DeepZ.plotAnnoPie.png" alt="DeepZ" width="500"/>

## 3. Анализ пересечений гистоновой метки и стр-ры ДНК

Найдём пересечение гистоновой метки и структуры ДНК при помощи команды:
```bash
bedtools intersect  -a DeepZ.bed   -b  H3K9me3_MCF7.merge.hg19.bed  >  H3K9me3_MCF7.intersect_with_DeepZ.bed
```

Построим гистограмму распределения длин пересечений гистоновой метки и структуры ДНК. Количество пиков 528:

<img src="/images/len_hist.H3K9me3_MCF7.intersect_with_DeepZ.png" alt="H3K9me3_MCF7.intersect_with_DeepZ" width="600"/>

Посмотрим, где располагаются участки пересечений относительно аннотированных генов.

<img src="/images/chip_seeker.H3K9me3_MCF7.intersect_with_DeepZ.plotAnnoPie.png" alt="H3K9me3_MCF7.intersect_with_DeepZ" width="500"/>

Визуализируем в геномном браузере исходные участки стр-ры ДНК, а также их пересечения с гистоновой меткой. Ссылка на сессию в геномном бруазере:

http://genome.ucsc.edu/s/avogar/hse21_H3K9me3_G4_human

Приведём 2 места пересечаения гистоновой метки со структурой ДНК.

- Ген ZNF300, координаты chr5:150,284,250-150,285,000:

<img src="/images/intersection1.png" alt="intersection1" width="2000"/>

- Ген LOC100499194, координаты chr2:114,737,200-114,737,700:

<img src="/images/intersection2.png" alt="intersection2" width="2000"/>

Произведём ассоциацию полученных пересечений с ближайшими генами при помощи программы [ChIPpeakAnno.R](https://github.com/Avogar/hse21_H3K9me3_DeepZ_human/blob/master/src/ChIPpeakAnno.R). Всего удалось проассоциировать 64 пика. Уникальных генов всего 46.

Проведём GO-анализ для полученных уникальных генов при помощи сайта http://pantherdb.org/. Приведем список наиболее статистически значимых категорий:

<img src="/images/go_categories.png" alt="go_categories" width="1000"/>
