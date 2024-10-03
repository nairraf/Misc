$screenShotPath = "D:\Program Files\Steam\userdata\86443413\760\remote\275850\screenshots"
$screenShotAnnotatePath = "$screenShotPath\Annotated"

if (-not(Test-Path -Path $screenShotAnnotatePath -PathType Container)) {
    New-Item -ItemType Directory -Path $screenShotAnnotatePath | Out-Null
}

$galaxies = @(
    "0. Pequibanu",
    "1. Euclid",
    "2. Hilbert Dimension",
    "3. Calypso",
    "4. Hesperius Dimension",
    "5. Hyades",
    "6. Ickjamatew",
    "7. Budullangr",
    "8. Kikolgallr",
    "9. Eltiensleen",
    "10. Eissentam",
    "11. Elkupalos",
    "12. Aptarkaba",
    "13. Ontiniangp",
    "14. Odiwagiri",
    "15. Ogtialabi",
    "16. Muhacksonto",
    "17. Hitonskyer",
    "18. Rerasmutul",
    "19. Isdoraijung",
    "20. Doctinawyra",
    "21. Loychazinq",
    "22. Zukasizawa",
    "23. Ekwathore",
    "24. Yeberhahne",
    "25. Twerbetek",
    "26. Sivarates",
    "27. Eajerandal",
    "28. Aldukesci",
    "29. Wotyarogii",
    "30. Sudzerbal",
    "31. Maupenzhay",
    "32. Sugueziume",
    "33. Brogoweldian",
    "34. Ehbogdenbu",
    "35. Ijsenufryos",
    "36. Nipikulha",
    "37. Autsurabin",
    "38. Lusontrygiamh",
    "39. Rewmanawa",
    "40. Ethiophodhe",
    "41. Urastrykle",
    "42. Xobeurindj",
    "43. Oniijialdu",
    "44. Wucetosucc",
    "45. Ebyeloofdud",
    "46. Odyavanta",
    "47. Milekistri",
    "48. Waferganh",
    "49. Agnusopwit",
    "50. Teyaypilny",
    "51. Zalienkosm",
    "52. Ladgudiraf",
    "53. Mushonponte",
    "54. Amsentisz",
    "55. Fladiselm",
    "56. Laanawemb",
    "57. Ilkerloor",
    "58. Davanossi",
    "59. Ploehrliou",
    "60. Corpinyaya",
    "61. Leckandmeram",
    "62. Quulngais",
    "63. Nokokipsechl",
    "64. Rinblodesa",
    "65. Loydporpen",
    "66. Ibtrevskip",
    "67. Elkowaldb",
    "68. Heholhofsko",
    "69. Yebrilowisod",
    "70. Husalvangewi",
    "71. Ovna'uesed",
    "72. Bahibusey",
    "73. Nuybeliaure",
    "74. Doshawchuc",
    "75. Ruckinarkh",
    "76. Thorettac",
    "77. Nuponoparau",
    "78. Moglaschil",
    "79. Uiweupose",
    "80. Nasmilete",
    "81. Ekdaluskin",
    "82. Hakapanasy",
    "83. Dimonimba",
    "84. Cajaccari",
    "85. Olonerovo",
    "86. Umlanswick",
    "87. Henayliszm",
    "88. Utzenmate",
    "89. Umirpaiya",
    "90. Paholiang",
    "91. Iaereznika",
    "92. Yudukagath",
    "93. Boealalosnj",
    "94. Yaevarcko",
    "95. Coellosipp",
    "96. Wayndohalou",
    "97. Smoduraykl",
    "98. Apmaneessu",
    "99. Hicanpaav",
    "100. Akvasanta",
    "101. Tuychelisaor",
    "102. Rivskimbe",
    "103. Daksanquix",
    "104. Kissonlin",
    "105. Aediabiel",
    "106. Ulosaginyik",
    "107. Roclaytonycar",
    "108. Kichiaroa",
    "109. Irceauffey",
    "110. Nudquathsenfe",
    "111. Getaizakaal",
    "112. Hansolmien",
    "113. Bloytisagra",
    "114. Ladsenlay",
    "115. Luyugoslasr",
    "116. Ubredhatk",
    "117. Cidoniana",
    "118. Jasinessa",
    "119. Torweierf",
    "120. Saffneckm",
    "121. Thnistner",
    "122. Dotusingg",
    "123. Luleukous",
    "124. Jelmandan",
    "125. Otimanaso",
    "126. Enjaxusanto",
    "127. Sezviktorew",
    "128. Zikehpm",
    "129. Bephembah",
    "130. Broomerrai",
    "131. Meximicka",
    "132. Venessika",
    "133. Gaiteseling",
    "134. Zosakasiro",
    "135. Drajayanes",
    "136. Ooibekuar",
    "137. Urckiansi",
    "138. Dozivadido",
    "139. Emiekereks",
    "140. Meykinunukur",
    "141. Kimycuristh",
    "142. Roansfien",
    "143. Isgarmeso",
    "144. Daitibeli",
    "145. Gucuttarik",
    "146. Enlaythie",
    "147. Drewweste",
    "148. Akbulkabi",
    "149. Homskiw",
    "150. Zavainlani",
    "151. Jewijkmas",
    "152. Itlhotagra",
    "153. Podalicess",
    "154. Hiviusauer",
    "155. Halsebenk",
    "156. Puikitoac",
    "157. Gaybakuaria",
    "158. Grbodubhe",
    "159. Rycempler",
    "160. Indjalala",
    "161. Fontenikk",
    "162. Pasycihelwhee",
    "163. Ikbaksmit",
    "164. Telicianses",
    "165. Oyleyzhan",
    "166. Uagerosat",
    "167. Impoxectin",
    "168. Twoodmand",
    "169. Hilfsesorbs",
    "170. Ezdaranit",
    "171. Wiensanshe",
    "172. Ewheelonc",
    "173. Litzmantufa",
    "174. Emarmatosi",
    "175. Mufimbomacvi",
    "176. Wongquarum",
    "177. Hapirajua",
    "178. Igbinduina",
    "179. Wepaitvas",
    "180. Sthatigudi",
    "181. Yekathsebehn",
    "182. Ebedeagurst",
    "183. Nolisonia",
    "184. Ulexovitab",
    "185. Iodhinxois",
    "186. Irroswitzs",
    "187. Bifredait",
    "188. Beiraghedwe",
    "189. Yeonatlak",
    "190. Cugnatachh",
    "191. Nozoryenki",
    "192. Ebralduri",
    "193. Evcickcandj",
    "194. Ziybosswin",
    "195. Heperclait",
    "196. Sugiuniam",
    "197. Aaseertush",
    "198. Uglyestemaa",
    "199. Horeroedsh",
    "200. Drundemiso",
    "201. Ityanianat",
    "202. Purneyrine",
    "203. Dokiessmat",
    "204. Nupiacheh",
    "205. Dihewsonj",
    "206. Rudrailhik",
    "207. Tweretnort",
    "208. Snatreetze",
    "209. Iwundaracos",
    "210. Digarlewena",
    "211. Erquagsta",
    "212. Logovoloin",
    "213. Boyaghosganh",
    "214. Kuolungau",
    "215. Pehneldept",
    "216. Yevettiiqidcon",
    "217. Sahliacabru",
    "218. Noggalterpor",
    "219. Chmageaki",
    "220. Veticueca",
    "221. Vittesbursul",
    "222. Nootanore",
    "223. Innebdjerah",
    "224. Kisvarcini",
    "225. Cuzcogipper",
    "226. Pamanhermonsu",
    "227. Brotoghek",
    "228. Mibittara",
    "229. Huruahili",
    "230. Raldwicarn",
    "231. Ezdartlic",
    "232. Badesclema",
    "233. Isenkeyan",
    "234. Iadoitesu",
    "235. Yagrovoisi",
    "236. Ewcomechio",
    "237. Inunnunnoda",
    "238. Dischiutun",
    "239. Yuwarugha",
    "240. Ialmendra",
    "241. Reponudrle",
    "242. Rinjanagrbo",
    "243. Zeziceloh",
    "244. Oeileutasc",
    "245. Zicniijinis",
    "246. Dugnowarilda",
    "247. Neuxoisan",
    "248. Ilmenhorn",
    "249. Rukwatsuku",
    "250. Nepitzaspru",
    "251. Chcehoemig",
    "252. Haffneyrin",
    "253. Uliciawai",
    "254. Tuhgrespod",
    "255. Iousongola",
    "256. Odyalutai",
    "257. -6 Loqvishess",
    "258. -5 Enyokudohkiw",
    "259. -4 Helqvishap",
    "260. -3 Usgraikik",
    "261. -2 Hiteshamij",
    "262. -1 Uewamoisow"
)

function print-galaxies {
    $galaxies | Format-Wide -Property {$_} -Column 4 -Force
}



while ($true){
    Write-Host "---------------------------------------"
    Write-Host "Welcome to the NMS Screenshot annotator"
    Write-Host "---------------------------------------"
    Write-Host ""
    Write-Host "Press P to print the list of galaxies"
    Write-Host "Press Q to exit"
    $uinput = (Read-Host "Please Enter the galaxy index").ToLower()
    if ($uinput -eq 'p') {
        print-galaxies
    }
    if ($uinput -eq 'q') {
        exit
    }
    try {
        $selection = [int]$uinput
        $galaxyName = $galaxies[$selection]
        "you selected: $galaxyName"
        $confirm = (Read-Host "Is this correct [y/n]?").ToLower()
        if ($confirm -eq 'y') {
            break
        }
    } catch {
        Write-Host "Please enter a valid galaxy number"
        continue
    }
}

"you selected: $galaxyName"

 # regenerating the anotation image
 magick.exe -size 400x100 xc:none -font Candice -pointsize 30 `
 -stroke black -strokewidth 8 -annotate +25+65 $galaxyName -blur 0x8 `
 -fill white   -stroke none   -annotate +25+65 $galaxyName `
 "$screenShotAnnotatePath\anotate.png"



while ($true){
    ""
    "searching for new screenshots to annotate.."
    # see if we have any screenshots that haven't been annotated
    $completed = Get-ChildItem -Path $screenShotAnnotatePath -Filter '*.jpg'
    foreach ($pic in Get-ChildItem -Path $screenShotPath -Filter '*.jpg') {
    
        if (0 -lt $completed.count -and $completed.Name.Contains($pic.Name)) {
            #Write-Host "$($pic.Name) already annotated, skipping"
            continue
        }
    
        Write-Host "Annotating $($pic.Name).."
        magick.exe composite -gravity NorthEast `
        "$screenShotAnnotatePath\anotate.png" $pic.FullName "$screenShotAnnotatePath\$($pic.Name)"
        magick.exe "$screenShotAnnotatePath\$($pic.Name)" -border 5  "$screenShotAnnotatePath\$($pic.Name)"
    
    }
    "sleeping for 10 seconds"
    "press ctrl-c to exit"
    Start-Sleep -Seconds 10
}

    