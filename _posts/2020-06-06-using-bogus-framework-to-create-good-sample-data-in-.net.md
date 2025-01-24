---
layout: post
title: Bogus Framework
subtitle:  Using Bogus Framework to Create Good Sample Data In .Net
cover-img: /assets/img/topimg.jpg
thumbnail-img: /assets/img/tn-tut.jpg
share-img: /assets/img/path.jpg
tags: [c#, dotnet, test, tutorial]
author: Martijn
---

Whenever you create a unittest or just need some sample data, you'll probably begin by making up a couple of testvalues. Your test UI-screen looks nice, everything is lined up perfectly fine. And then when your program goes live, some user has a really long name and another one has a name with a diacritic in it (you know: e.g. a ç) and someone points out that your UI looks weird.

No worries, of course, you fix those cases and even think of another thing that could go have gone wrong in the progress. Suddenly you have written out quite some lines of sample data and you wonder how many special cases you missed? Do you need more sampledata? How much will be enough? You don't have time to write 1000s of lines with intelligent sample data.

Enter [Bogus Framework](https://github.com/bchavez/Bogus): a framework specifically designed to create sample data. And the great part: it's very easy to use.

In this small tutorial, I will show you, in just a few steps, to easily get realistic locale-specific sample data in your .net core program with just a few lines of code and Bogus.

So let's start by creating a new .net console application.

1. with dotnet installed, create a directory this_is_bogus, move into the directory and create a new empty project
    ```` bat
    mkdir this_is_bogus
    cd this_is_bogus
    dotnet new console
    ````

2. now add the bogus framework.
    ```` bat
    dotnet add package Bogus
    ````


3. open vs code   
    ```` bat
    code .
    ````
     
   
4. Create a new file called resident.cs, this class will contain some information about  a resident in a country.
    ```` c# 
    using System.Collections.Generic;
    using System.Text;

    public class Resident
    {
        public string? Name { get; set; }
        public string? Id { get; set; }
        public string? Street { get; set; }
        public string? Housenumber { get; set; }

        public string? City { get; set; }

        public void Print()
        {
            Console.WriteLine($"{Name}	{Street}	{Housenumber}	{City}	{Id}");
        }
    }
    ````

5. Now change the Program.cs file into the following:
   ```` c# 
    using Bogus;
    using System;


    var resident = new Resident { Name = "Jan van Bommelen", Street = "Rijksweg", Housenumber = "3", City = "AAAA" };
    resident.Print();
   ````

6. let's give this a try.
   ```` bat
   dotnet run
   ````

7. This should build and run, There is no Bogus magic happening yet. There is just one resident created with the pre made up values. On purpose, I chose a City name that displays a lack of creativity. Also, I figured it would be nice to use a Dutch name and address. 
   ```` csv
   Jan van Bommelen        Rijksweg        3       AAAA
   ````   

8. Now let's introduce some Bogus! Change the code in Program.cs into:
   ```` c#
    var residents = new Faker()
                    .StrictMode(false)
                    .Rules((f, o) =>
                    {
                        o.Id = f.Random.Replace("###-###-###-###");
                        o.Name = f.Name.FullName();
                        o.Street = f.Address.StreetName();
                        o.Housenumber = f.Address.BuildingNumber();
                        o.City = f.Address.City();
                    });
    var residentList = residents.Generate(10);
    foreach (var res in residentList)
    {
        res.Print();
    }   
   ```` 

 9. Now if you'd run this, you get something like this (but not the same) in your console:
    ```` csv
    Kailyn Crist    Walsh Skyway    52320   East Sadyeberg  194-616-417-300
    Elisa Luettgen  Sporer Rest     966     South Evalynport 304-076-025-042
    Hildegard Skiles        Keira Street    3203    West Glennastad 582-080-420-660
    Clara Nicolas   Rogers Island   9841    East Jesusland  040-413-147-217
    Ashton Leannon  Lemke Run       029     Weststad        476-821-717-523
    Anderson Feeney Mayert Ville    6918    Tellyborough    567-187-060-711
    Onie Kulas      Ophelia Pass    776     Lake Rigoberto  629-476-369-444
    Hellen Reilly   Osvaldo Cliffs  6255    West Alisaland  963-221-067-038
    Giovanni O'Kon  Harris Summit   6626    Faheyborough    344-887-180-423
    Otho Mosciski   Marcelino Greens        6789    Kuphalton       145-335-225-633
    ````

10. Of course, this looks awesome already. On the other hand, For my purpose I want Dutch names and addresses. And changing this is easy in Bogus: If you want Dutch names and addresses (or any countries real looking data ), just add a constructer argument for the locale to the Faker. The Dutch locale is "NL" (short for Netherlands).
So just changing the line 
    ```` c#
        var residents = new Faker<Resident>()
    ````
into
    ```` c#
        var residents = new Faker<Resident>("nl")
    ````
will generate the following console output:
    ```` csv
    Femke Vries     Sophiestraat    158 I   Zelder  991-261-740-125
    Ruben Haan      Jonggracht      866a    Busselveld      731-249-514-880                                                       
    Julia Bos       Heuvelgracht    258 I   Schouwenlaar    088-558-975-631
    Jasper Vliet    Damplein        200 I   Deelenberg      034-285-176-563
    Tim Visser      Basgracht       6       Bult    098-067-829-305
    Finn Meijer     Daanstraat      7       Leiden  318-743-732-161
    Jesse Koster    Isastraat       013b    Engwierumhuizen 537-323-519-104
    Stijn Boer      Petersrijk      570b    Werk    621-096-674-910
    Noa Peters      Koninggracht    766b    Stokkelen       118-664-094-853
    Nick Broek      Ambervelt       11      Aalsum  063-909-590-926
    ````

11. Voila, Dutch names and Dutch addresses. For automated testing it's handy to generate the same "random" dataset. And Bogus helps with that as well.  This too, can be easily done: just add a random seed. When you setup the Faker add the following line:
    ```` c#
    .UseSeed(2345)
    ````
so it will become:
    ```` c#
    var residents = new Faker<Resident>("nl")
        .StrictMode(false)
        .UseSeed(2345)
        .Rules((f, o) =>
        ...
    ````    
this will create the same list everytime you run and rerun the program. (You don't have to pick 2345, that was random)

12. If you want more chance on special characters you can set your locale to "fr" (France) or "ko" (Korean).
    ```` csv
    Inès Rodriguez  Place du Dahomey        0291    Saint-Denis     123-530-611-587
    Michèle Masson  Allée d'Assas    9195    Pau     758-755-992-345
    서연 오 중계읍  9396    인제시  617-709-031-784
    지훈 김 상도동  624     광산구  421-492-186-337
    ````

13. And with that you've come to the end of this tutorial. Please note that Bogus is capable of doing way more cool stuff.

You could define your own enums where it could randomly pick values of, It supports [lots of locales](https://github.com/bchavez/Bogus#locales) and it has a lot of [datasets and definitions](https://github.com/bchavez/Bogus#bogus-api-support) that you can instantly use and much much more.