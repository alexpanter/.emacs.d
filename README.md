# .emacs.d
Epic Emacs settings, only for C++ (currently).

Clone this repository at the appropriate place for the `.emacs.d/` directory and a standardized experience.

Currently this repository targets only development in C and C++ with minimal setup and support.

# Commands to remember

With Helm and sematic, there's a number of really cool commands:

- `C-x C-b` for ibuffer
- `C-c h` for helm prefix
- `C-c h m` for man pages
- `C-c h s` for browsing semantic tags
- `C-c h o` for helm-occur
-
- `M-s o` for static occur in another buffer (very useful)
- `M-s h l` for highlight lines matching regex
- `M-s h u` for un-highlight lines matching regex

If `locate` and `updatedb` are installed (likely same package), then Helm can be
used to locate any file on machine. Procedure:
```
sudo updatedb --prunepaths='/run/user/1000 /run/user/127'
```
`prunepaths` may be necessary for broken permissions. Next, locate can be used
within Emacs:
-  `C-c h l` for locating file matching pattern
- `C-c S-x` for opening the selected file externally in default application


# TODO-list of desired features #

* Term-mode with colors
* Header-search auto-completion
* Language-sensitive auto-completion
* NO default flycheck!
* optional flycheck (GCC, g++-20, enabled on a per-need basis)
* Helm and Helm-gtags
* tab-indentation (visually 4 spaces)
* Color theme (Desktop setup)
* gdb-settings
* custom winmove settings
* FIXED window resize
* automatic download of packages (optionally also updates, but only minor versions)
* jump-to-reference
* symbol lookup (global, file-local)
* refactor renaming (if possible)
* on point show symbol signature in minibuffer
* auto-completion list with jump-to-definition
* documentation-string popup for symbol on mouse hover, or similar feature (company not ac)
* other clever tuhdo-features
* NO gtags parsing of headers when point is in a comment!
