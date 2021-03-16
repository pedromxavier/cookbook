\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{textbook}[2020/01/01 Week class]

%%%% -------- PACKAGES -----------
\RequirePackage[utf8]{inputenc}
\RequirePackage{ifthen}
\RequirePackage{suffix}

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

%%%% -------- PACKAGES -----------
\RequirePackage{float}
\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{helvet}
\RequirePackage{courier}
\RequirePackage{ragged2e}
\RequirePackage{enumitem}
\RequirePackage{hyperref}

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

\newcommand*{\userlanguage}{\@ulang}%%

%%%% Require main package
\RequirePackage{textbook-colors}
\RequirePackage{textbook-listing}

%%%% -------- PARAMETERS ---------
\newcommand{\subtitle}[1]{\renewcommand\@subtitle{\sffamily #1}}%%
\newcommand\@subtitle{~}%%

\newcommand{\publisher}[1]{\renewcommand\@publisher{#1}}%%
\newcommand\@publisher{~}%%

\newcommand{\titlecomment}[1]{\renewcommand\@titlecomment{#1}}%%
\newcommand\@titlecomment{~}%%

\newcommand{\titleimage}[2][]{%%
    \renewcommand\@titleimage{%%
        \begin{figure}[H]
            \centering
            \includegraphics[#1]{#2}
        \end{figure}[H]
    }}%%
\newcommand\@titleimage{~}%%

\renewcommand{\title}[1]{\renewcommand\@title{\HUGE\textsc #1}}

\renewcommand{\baselinestretch}{1.15} 

%% --------- ENVIRONMENTS ------------
\RequirePackage{textbook-environments}

\newcommand{\proposal}{%%
    \medskip\noindent
    {\bfseries\translate[to=\@ulang]{Proposal}}\\
}

\newcommand{\preface}{%%
    \translatelet[to=\@ulang]\trans@temp{Preface}
    \chapter*{\texorpdfstring{\trans@temp}{Preface}}%%
}

\newcommand{\prefacenote}[1]{%%
    \bigskip%%
    \begin{flushright}
        #1%%
    \end{flushright}
}

\RequirePackage{textbook-commands}
\endinput