\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{week}[2020/01/01 Week class]

%%%% -------- PACKAGES -----------
\RequirePackage{calc}
\RequirePackage{intcalc}
\RequirePackage{ifthen}
\RequirePackage{suffix}
\RequirePackage{fmtcount}% http://ctan.org/pkg/fmtcount
\RequirePackage[utf8]{inputenc}
\RequirePackage{translator}

%%%% -------- PACKAGES -----------
\RequirePackage{../switch/switch}
\RequirePackage{../pastel/pastel}

%%%% -------- OPTIONS -----------
%% Debug
\newboolean{debug}
\setboolean{debug}{false}
\DeclareOption{debug}{%
    \setboolean{debug}{true}
}

%% Language
\def\ulang{en}%%
\DeclareOption{en}{%
    \def\ulang{en}
}

\DeclareOption{br}{%
    \def\ulang{br}
}

\DeclareOption{de}{%
    \def\ulang{de}
}

\ProcessOptions%%

\LoadClass[tikz]{standalone}

%%%% -------- LANGUAGE -----------
\uselanguage{\ulang}
\languagepath{\ulang}

%%%% PT_BR
\deftranslation[to=br]{Monday}   {Segunda}%
\deftranslation[to=br]{Tuesday}  {Terça}%
\deftranslation[to=br]{Wednesday}{Quarta}%
\deftranslation[to=br]{Thursday} {Quinta}%
\deftranslation[to=br]{Friday}   {Sexta}%
\deftranslation[to=br]{Saturday} {Sábado}%
\deftranslation[to=br]{Sunday}   {Domingo}%
%%%% DE
\deftranslation[to=de]{Monday}   {Montag}%
\deftranslation[to=de]{Tuesday}  {Dienstag}%
\deftranslation[to=de]{Wednesday}{Mittwoch}%
\deftranslation[to=de]{Thursday} {Donnerstag}%
\deftranslation[to=de]{Friday}   {Freitag}%
\deftranslation[to=de]{Saturday} {Samstag}%
\deftranslation[to=de]{Sunday}   {Sonntag}%

%%%% -------- COUNTERS -----------
\newcounter{hour}
\newcounter{day}


%%%% ------- PARAMETERS ----------
\def\param@cellwidth{3.25}
\def\param@cellheight{0.8}

\def\param@padxl{1.85}
\def\param@padxr{1.85}
\def\param@padyt{4}
\def\param@padyb{1}

\def\param@day{0}%% Sunday
%\def\param@day{1}%% Monday

\def\param@ndays{7}%%
\newcommand{\setndays}[1]{%%
    \def\param@ndays{#1}
}

\newcommand{\sethours}[2]{%%
    \sethour{#1}
    \setnhours{\numexpr#2-#1\relax}
}

\def\param@hour{6}%%
\newcommand{\sethour}[1]{%%
    \def\param@hour{#1}
}

\def\param@nhours{16}%%
\newcommand{\setnhours}[1]{%%
    \def\param@nhours{\numexpr#1+1\relax}
}

\renewcommand{\title}[1]{%%
    \renewcommand\@title{#1}
}
\def\@title{}%%

\newcommand{\subtitle}[1]{%%
    \renewcommand\@subtitle{#1}
}
\def\@subtitle{}%%

\newenvironment{week}{
    \begin{tikzpicture}
        \makeframe
}{%%
    \end{tikzpicture}
}

\newcommand{\makeframe}{%%
    \def\w{\param@cellwidth}
    \def\h{\param@cellheight}
    \def\pxl{\param@padxl}
    \def\pxr{\param@padxr}
    \def\pyt{\param@padyt}
    \def\pyb{\param@padyb}
    \def\nd{\param@ndays}
    \def\nh{\param@nhours}

    \makearea
    %% Draw Grid for each day
    \makegrid

    \maketext

}

\newcommand{\makearea}{%%
    \ifthenelse{\boolean{debug}}{%%
        \draw[dashed, thick] (0,0) rectangle (\w * \nd + \w + \pxl + \pxr, -\h * \nh - 2 * \h - \pyt - \pyb);
        \draw[red, dashed, ultra thick] (0, 0) rectangle (297mm, -210mm);  %% A4
    }{%%else
    \draw[draw=none] (0,0) rectangle (\w * \nd + \w + \pxl + \pxr, -\h * \nh - 2 * \h - \pyt - \pyb);
    }
}

\newcommand{\makegrid}{%%
    \foreach \i in {0, ..., \nd} %% for each day
    {
        \draw [black!40] (\i * \w + \w + \pxl, -\pyt) -- (\i * \w + \w + \pxl, -\h * \nh - \h - \pyt);
    }
    \foreach \j in {0, ..., \nh} %% for each hour
    {   
        \draw [black!40] (\pxl, -\j * \h - \h -\pyt) -- (\w * \nd + \w + \pxl, -\j * \h - \h - \pyt);
    }
}

\newcommand{\maketext}{%%
    \maketitle
    \makehours
    \makedays
}

\renewcommand{\maketitle}{
    \node [align=center] at (0.5 * \nd * \w + 0.5 * \w + \pxl, - 0.7 * \pyt) {{\Huge\bfseries \@title}\\[1ex] {\large \@subtitle}};
}

\newcommand{\makehours}{
    \setcounter{hour}{\param@hour}
    \foreach \j in {1, ..., \nh} %% for each hour
    {   
        \node [] at (0.5 * \w + \pxl, -\j * \h - 0.5 * \h -\pyt) {\gethour};
        \stepcounter{hour}%%
    }
}

\newcommand{\gethour}{%%
    {\padzeroes[2]{\decimal{hour}}:00}
}

\newcommand{\makedays}{
    \setcounter{day}{\param@day}
    \foreach \i in {1, ..., \nd} %% for each day
    {
        \node [] at (\i * \w + 0.5 * \w + \pxl, -0.5 * \h -\pyt) {\getday};
        \stepcounter{day}%%
    }
}

\newcommand{\getday}{%%
    \begin{switch}{\intcalcMod{\theday}{7}}%%
        \hspace*{-10pt}
        \case{0}{\translate[to=\ulang]{Sunday}}%%
        \case{1}{\translate[to=\ulang]{Monday}}%%
        \case{2}{\translate[to=\ulang]{Tuesday}}%%
        \case{3}{\translate[to=\ulang]{Wednesday}}%%
        \case{4}{\translate[to=\ulang]{Thursday}}%%
        \case{5}{\translate[to=\ulang]{Friday}}%%
        \case{6}{\translate[to=\ulang]{Saturday}}%%
        \default{\translate[to=\ulang]{Today}}%%
    \end{switch}%%
}

\newcommand\task[5][p-blue]{%%
    \xtask[#1]{#2}{#3}{1}{#4}{#5}%%
}

\newcommand\xtask[6][p-blue]{%%
    \draw [fill=#1, draw=#1, rounded corners] (#3 * \w + \w + \pxl, -#5 * \h - \h - \pyt + \param@hour * \h) rectangle (#3 * \w + \w + #4 * \w + \pxl, -#5 * \h - #6 * \h - \h - \pyt + \param@hour * \h) node[midway, align=center] {#2};
}

\endinput