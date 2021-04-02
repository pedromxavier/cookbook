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
\RequirePackage{helvet}
\RequirePackage{inconsolata}
\RequirePackage{ragged2e}
\RequirePackage{enumitem}
\RequirePackage{hyperref}

%%%% ----- PGF & TIKZ -----
\RequirePackage{tikz}
\usetikzlibrary{arrows}

%% check compiler
\ifpdf
    \RequirePackage{pdfcolmk}
\fi
%% check if using xelatex rather than pdflatex
\ifxetex
    \RequirePackage{fontspec}
\fi

\setuptranslate%

\RequirePackage{textbook-commands}
\RequirePackage{textbook-colors}
\RequirePackage{textbook-listing}
\RequirePackage{textbook-config}
\RequirePackage{textbook-environments}

\endinput