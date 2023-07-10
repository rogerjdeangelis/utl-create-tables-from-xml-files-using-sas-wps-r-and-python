%let pgm=utl-create-tables-from-xml-files-using-sas-wps-r-and-python;

Create tables from xml files using sas wps r and python

github
https://tinyurl.com/4vttbn7u
https://github.com/rogerjdeangelis/utl-create-tables-from-xml-files-using-sas-wps-r-and-python

   SOLUTIONS

        1 WPS/SAS (proc contents to describe xml file)
        2 WPS/SAS (sql and datastep)
        3 R
        4 Python (python seems very capable but also very complex?)
          https://medium.com/@robertopreste/from-xml-to-pandas-dataframes-9292980b1c1c

StackOverflow
https://stackoverflow.com/questions/76638516/collecting-all-codes-and-the-associated-descriptive-text-in-r-scraping

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

/*----  copy this xml file to d frive folder xml                         ----*/
filename ft15f001 "d:/xml/havpy.xml";
parmcards4;
<data>
    <student name="John">
        <email>john@mail.com</email>
        <grade>A</grade>
        <age>16</age>
    </student>
    <student name="Alice">
        <email>alice@mail.com</email>
        <grade>B</grade>
        <age>17</age>
    </student>
    <student name="Bob">
        <email>bob@mail.com</email>
        <grade>C</grade>
        <age>16</age>
    </student>
    <student name="Hannah">
        <email>hannah@mail.com</email>
        <grade>A</grade>
        <age>17</age>
    </student>
</data>
;;;;
run;quit;


/*                         __                               _             _
/ | __      ___ __  ___   / /__  __ _ ___    ___ ___  _ __ | |_ ___ _ __ | |_ ___
| | \ \ /\ / / `_ \/ __| / / __|/ _` / __|  / __/ _ \| `_ \| __/ _ \ `_ \| __/ __|
| |  \ V  V /| |_) \__ \/ /\__ \ (_| \__ \ | (_| (_) | | | | ||  __/ | | | |_\__ \
|_|   \_/\_/ | .__/|___/_/ |___/\__,_|___/  \___\___/|_| |_|\__\___|_| |_|\__|___/
*/           |_|

libname xmlinp xml "d:/xml/havpy.xml" xmltype=generic;
proc contents data=xmlinp._all_;
run;quit;

/*
__      ___ __  ___
\ \ /\ / / `_ \/ __|
 \ V  V /| |_) \__ \
  \_/\_/ | .__/|___/
         |_|
*/

%utl_submit_wps64x('
libname xmlinp xml "d:/xml/havpy.xml" xmltype=generic;
proc contents data=xmlinp._all_;
run;quit;
');

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  The WPS System                                                                                                        */
/*                                                                                                                        */
/*  The CONTENTS Procedure                                                                                                */
/*                                                                                                                        */
/*  Data Set Name           STUDENT   Deleted Observations             0                                                  */
/*  Member Type             DATA      Data Set Type                                                                       */
/*  Engine                  XML       Label                                                                               */
/*  Observations                .     Compressed              NO                                                          */
/*  Variables               3         Sorted                  NO                                                          */
/*  Indexes                 0         Data Representation                                                                 */
/*  Observation Length      24        Encoding                wlatin1 Windows-1252                                        */
/*                                                                                                                        */
/*  Alphabetic List of Variables and Attributes                                                                           */
/*                                                                                                                        */
/*        Number    Variable    Type             Len             Pos    Format    Informat    Label                       */
/*  _______________________________________________________________________________________________                       */
/*             3    AGE         Num                8              16    F2.       F8.         age                         */
/*             1    EMAIL       Char              15               0    $15.      $15.        email                       */
/*             2    GRADE       Char               1              15    $1.       $1.         grade                       */
/*                                                                                                                        */
/*              Directory                                                                                                 */
/*                                                                                                                        */
/*  Libref           XMLINP                                                                                               */
/*  Engine           XML                                                                                                  */
/*  Physical Name    d:\xml\havpy.xml                                                                                     */
/*                                                                                                                        */
/*               Members                                                                                                  */
/*                                                                                                                        */
/*                  Member     Member                                                                                     */
/*        Number    Name       Type                                                                                       */
/*  _________________________________                                                                                     */
/*             1    STUDENT    DATA                                                                                       */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                          __                         _    ___         _       _            _
|___ \  __      ___ __  ___   / /__  __ _ ___   ___  __ _| |  ( _ )     __| | __ _| |_ __ _ ___| |_ ___ _ __
  __) | \ \ /\ / / `_ \/ __| / / __|/ _` / __| / __|/ _` | |  / _ \/\  / _` |/ _` | __/ _` / __| __/ _ \ `_ \
 / __/   \ V  V /| |_) \__ \/ /\__ \ (_| \__ \ \__ \ (_| | | | (_>  < | (_| | (_| | || (_| \__ \ ||  __/ |_) |
|_____|   \_/\_/ | .__/|___/_/ |___/\__,_|___/ |___/\__, |_|  \___/\/  \__,_|\__,_|\__\__,_|___/\__\___| .__/
                 |_|                                   |_|                                             |_|
*/

proc datasteps data=sd1 nolist noequals;
 delete want_datastep sd1.want_datastep;
run;quit;

libname sd1 "d:/sd1";
libname xmlinp xml "d:/xml/havpy.xml" xmltype=generic;

proc sql;
  create
    table sd1.want_sql as
  select
    *
  from
    xmlinp.student
;quit;

data sd1.want_datastep;
  set xmlinp.student ;
run;quit;

proc print data=sd1.want_sql;
  title "xlm file to sas sql table";
run;quit;

proc print data=sd1.want_sql;
  title "xlm file to sas datastep table";
run;quit;

libname xmlinp clear;

/*
__      ___ __  ___
\ \ /\ / / `_ \/ __|
 \ V  V /| |_) \__ \
  \_/\_/ | .__/|___/
         |_|
*/

proc datasteps data=sd1 nolist noequals;
 delete want_datastep sd1.want_datastep;
run;quit;

%utl_submit_wps64x('
libname sd1 "d:/sd1";
libname xmlinp xml "d:/xml/havpy.xml" xmltype=generic;

proc sql;
  create
    table sd1.want_sql as
  select
    *
  from
    xmlinp.student
;quit;


data sd1.want_datastep;
  set xmlinp.student ;
run;quit;

proc print data=sd1.want_sql;
  title "xlm file to wps sql table";
run;quit;

proc print data=sd1.want_sql;
  title "xlm file to wps datastep table";
run;quit;

libname xmlinp clear;
');
/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

/**************************************************************************************************************************/
/*                                                                                                                        */
/*                                                                                                                        */
/*  xlm file to wps SQL table                                                                                             */
/*                                                                                                                        */
/*  Obs    EMAIL              GRADE    AGE                                                                                */
/*                                                                                                                        */
/*   1     john@mail.com        A       16                                                                                */
/*   2     alice@mail.com       B       17                                                                                */
/*   3     bob@mail.com         C       16                                                                                */
/*   4     hannah@mail.com      A       17                                                                                */
/*                                                                                                                        */
/*  xlm file to wps DATASTEP table                                                                                        */
/*                                                                                                                        */
/*  Obs    EMAIL              GRADE    AGE                                                                                */
/*                                                                                                                        */
/*   1     john@mail.com        A       16                                                                                */
/*   2     alice@mail.com       B       17                                                                                */
/*   3     bob@mail.com         C       16                                                                                */
/*   4     hannah@mail.com      A       17                                                                                */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*____
|___ /   _ __
  |_ \  | `__|
 ___) | | |
|____/  |_|

*/

proc datasteps data=sd1 nolist noequals;
 delete want;
run;quit;

%utl_submit_wps64('
libname sd1 "d:/sd1";
proc r;
submit;
library(tidyverse);
library(xml2);
cl_xml <- xml2::read_xml("d:/xml/havpy.xml");
want<-xml2::as_list(cl_xml)[[1]] |>
  dplyr::bind_rows() |>
  tidyr::unnest(everything());
head(want);
str(want);
endsubmit;
import data=sd1.want r=want;
proc print data=sd1.want;
run;quit;
');

/**************************************************************************************************************************/
/*                                                                                                                        */
/* The WPS System                                                                                                         */
/*                                                                                                                        */
/* # A tibble: 4 x 3                                                                                                      */
/*   email           grade age                                                                                            */
/*   <chr>           <chr> <chr>                                                                                          */
/* 1 john@mail.com   A     16                                                                                             */
/* 2 alice@mail.com  B     17                                                                                             */
/* 3 bob@mail.com    C     16                                                                                             */
/* 4 hannah@mail.com A     17                                                                                             */
/*                                                                                                                        */
/* The WPS System                                                                                                         */
/*                                                                                                                        */
/* Obs         EMAIL         GRADE    AGE                                                                                 */
/*                                                                                                                        */
/*  1     john@mail.com        A      16                                                                                  */
/*  2     alice@mail.com       B      17                                                                                  */
/*  3     bob@mail.com         C      16                                                                                  */
/*  4     hannah@mail.com      A      17                                                                                  */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*  _                 _   _
| || |    _ __  _   _| |_| |__   ___  _ __
| || |_  | `_ \| | | | __| `_ \ / _ \| `_ \
|__   _| | |_) | |_| | |_| | | | (_) | | | |
   |_|   | .__/ \__, |\__|_| |_|\___/|_| |_|
         |_|    |___/
*/

proc datasteps data=sd1 nolist noequals;
 delete want;
run;quit;

%utl_submit_wps64('
libname sd1 "d:/sd1";
proc python;
submit;
import pandas as pd;
import xml.etree.ElementTree as et;
xtree = et.parse("d:/xml/havpy.xml");
xroot = xtree.getroot();
df_cols = ["name", "email", "grade", "age"];
rows = [];
for node in xroot:;
.   s_name = node.attrib.get("name");
.   s_mail = node.find("email").text if node is not None else None;
.   s_grade = node.find("grade").text if node is not None else None;
.   s_age = node.find("age").text if node is not None else None;
.   rows.append({"name": s_name, "email": s_mail,;
.                "grade": s_grade, "age": s_age});
out_df = pd.DataFrame(rows, columns = df_cols);
print(out_df);
endsubmit;
import data=sd1.want python=out_df;
proc print data=sd1.want;
run;quit;
');

/**************************************************************************************************************************/
/*                                                                                                                        */
/* The WPS System                                                                                                         */
/*                                                                                                                        */
/* The PYTHON Procedure                                                                                                   */
/*                                                                                                                        */
/*      name            email grade age                                                                                   */
/* 0    John    john@mail.com     A  16                                                                                   */
/* 1   Alice   alice@mail.com     B  17                                                                                   */
/* 2     Bob     bob@mail.com     C  16                                                                                   */
/* 3  Hannah  hannah@mail.com     A  17                                                                                   */
/*                                                                                                                        */
/*                                                                                                                        */
/* Obs     NAME          EMAIL         GRADE    AGE                                                                       */
/*                                                                                                                        */
/*  1     John      john@mail.com        A      16                                                                        */
/*  2     Alice     alice@mail.com       B      17                                                                        */
/*  3     Bob       bob@mail.com         C      16                                                                        */
/*  4     Hannah    hannah@mail.com      A      17                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
