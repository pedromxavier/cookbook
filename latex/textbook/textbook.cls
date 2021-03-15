\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{textbook}[2020/01/01 Week class]

%%%% -------- PACKAGES -----------
\RequirePackage{ifthen}
\RequirePackage{suffix}
\RequirePackage[utf8]{inputenc}

%%%% -------- PACKAGES ------------
\RequirePackage{textbook-translate}

%%%% -------- OPTIONS -----------
%% Debug
\newboolean{debug}
\setboolean{debug}{false}
\DeclareOption{debug}{%
    \setboolean{debug}{true}
}

\newboolean{darktheme}
\setboolean{darktheme}{false}
\DeclareOption{dark}{%%
    \setboolean{darktheme}{true}    
}

%% Language
\def\ulang{en}%%
\DeclareOption{en}{%
    \setulang{en}
}

\DeclareOption{br}{%
    \setulang{br}
}

\DeclareOption{de}{%
    \setulang{de}
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}

\ProcessOptions%%
\LoadClass{memoir}

%%%% chapter* command
\newcommand\chapterx[2][\empty]{%%
    \ifthenelse{\equal{#1}{\empty}}{%% IF
        \chapter*{#2}
        \addcontentsline{toc}{chapter}{#2}
    }{%% ELSE
        \chapter*[#1]{#2}
        \addcontentsline{toc}{chapter}{#1}
    }
}

%%%% -------- PACKAGES -----------
\RequirePackage{calc}
\RequirePackage{intcalc}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}
\RequirePackage{float}
\RequirePackage{url}
\RequirePackage{graphicx}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{tikz}
\RequirePackage{pifont}
\RequirePackage{ragged2e}

%% check compiler
\ifpdf
    \RequirePackage{pdfcolmk}
\fi
%% check if using xelatex rather than pdflatex
\ifxetex
    \RequirePackage{fontspec}
\fi


%%%% -------- LANGUAGE ----------
\ifthenelse{\equal{\@ulang}{br}}{
    \RequirePackage[brazil]{babel}
}{%%%
    %% Do Nothing
}

%%%% Require main package
\RequirePackage{textbook}

%%%% -------- PARAMETERS ---------
\newcommand{\subtitle}[1]{\renewcommand\@subtitle{#1}}%%
\newcommand\@subtitle{~}%%

\newcommand{\publisher}[1]{\renewcommand\@publisher{#1}}%%
\newcommand\@publisher{~}%%

\newcommand{\titlecomment}[1]{\renewcommand\@titlecomment{#1}}%%
\newcommand\@titlecomment{~}%%

\renewcommand{\title}[1]{\renewcommand\@title{\HUGE\textsc #1}}

\renewcommand{\baselinestretch}{1.15} 

%%%% -------- TITLE PAGE --------
\newlength{\drop}% for my convenience
%% specify the Webomints family
\newcommand*{\wb}[2]{\fontsize{#1}{#2}\usefont{U}{webo}{xl}{n}}
%% select a (FontSite) font by its font family ID
\newcommand*{\FSfont}[1]{\fontencoding{T1}\fontfamily{#1}\selectfont}
%% if you don’t have the FontSite fonts either \renewcommand*{\FSfont}[1]{}
%% or use your own choice of family.
%% select a (TeX Font) font by its font family ID
\newcommand*{\TXfont}[1]{\fontencoding{T1}\fontfamily{#1}\selectfont}
%% Generic publisher’s logo
\newcommand*{\plogo}{\fbox{$\mathcal{PL}$}}

%%%% light series
%% e.g., kernel doc, section s: line 12 or thereabouts
\DeclareRobustCommand\ltseries
{\not@math@alphabet\ltseries\relax
\fontseries\ltdefault\selectfont}
%% e.g., kernel doc, section t: line 32 or thereabouts
\newcommand{\ltdefault}{l}
%% e.g., kernel doc, section v: line 19 or thereabouts
\DeclareTextFontCommand{\textlt}{\ltseries}
% heavy(bold) series
\DeclareRobustCommand\hbseries{\not@math@alphabet\hbseries\relax
\fontseries\hbdefault\selectfont}
\newcommand{\hbdefault}{hb}
\DeclareTextFontCommand{\texthb}{\hbseries}

\newcommand{\maketitlepage}{%%
    \pagestyle{empty}
    \begingroup% Three Men in a Boat
    \drop=0.1\textheight
    \centering
    \settowidth{\unitlength}{\@title}
    \vspace*{\baselineskip}
    {\large\scshape \@author}\\[\baselineskip]
    \rule{\unitlength}{1.6pt}\vspace*{-\baselineskip}\vspace*{2pt}
    \rule{\unitlength}{0.4pt}\\[\baselineskip]
    {\@title}\\[\baselineskip]
    {\itshape \@subtitle}\\[0.2\baselineskip]
    \rule{\unitlength}{0.4pt}\vspace*{-\baselineskip}\vspace{3.2pt}
    \rule{\unitlength}{1.6pt}\\[\baselineskip]
    {\large\scshape \@titlecomment}\par
    \vfill
    {\large\scshape \@publisher}\\[\baselineskip]
    {\small\scshape \the\year}\par
    \vspace*{\drop}
    \endgroup
    \clearpage
}

\newlength{\sectionskip}
\setlength{\sectionskip}{1ex}
\WithSuffix\newcommand\section*[1]{%%
    \addtocounter{section}{1}
    \bigskip\noindent%%
    {\LARGE\bfseries #1}\\[\sectionskip]%%
    \addcontentsline{toc}{section}{#1}%%
    \noindent%%
}

%% --------------- PROBLEM ENVIRONMENT -----------------
%% Lengths
\newlength{\problemstep}
\setlength{\problemstep}{0ex}
\newlength{\problemskip}
\setlength{\problemskip}{-1ex}
%% Style
\newcommand*{\problemstyle}{
    \large\bfseries%%
}
%% Numbering
\newcommand*{\problemnum}{%
    \arabic{chapter}.\arabic{subsection}%%
}

\newenvironment{problem}[2][]{%%
    \addtocounter{subsection}{1}
    \settowidth{\problemstep}{\problemstyle\problemnum~~}%%
    \bigskip\noindent\hspace*{-\problemstep}
    {\problemstyle\problemnum~#2}\\[\problemskip]%%
    \addcontentsline{toc}{subsection}{\problemstyle\problemnum~#2}%%
    \ifthenelse{\equal{#1}{}}{%%
        %% Do nothing
    }{
        \label{#1} %% Add Label for referencing
    }%%
    \noindent%
    \begin{adjustwidth}{0cm}{0pt}
}{
    \end{adjustwidth}
}

\newcommand{\proposal}{%%
    \medskip\noindent
    {\bfseries \translate[to=\@ulang]{Proposal}}\\
}

\newcommand{\preface}{%%
    \chapter{\translate[to=\@ulang]{Preface}}%%
}

\newcommand{\prefacenote}[1]{%%
    \bigskip%%
    \begin{flushright}
        #1%%
    \end{flushright}
}

%%\setlength{\parindent}{0pt}