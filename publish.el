    (setq blog-path "~/Code/personal_site/")
    (setq blog-static-path (concat blog-path "html/"))
    (setq blog-content-path (concat blog-path "pages/"))
    (setq blog-templates (concat blog-path "/assets/templates/"))
    (setq kb-static-path "~/Notes/html")
    (setq kb-content-path "~/Notes/pages/")
    (setq kb-static-path "~/Notes/html/daily")
    (setq kb-content-path "~/Notes/journals/")
    (setq org-publish-sitemap-sort-files 'anti-chronologically)
  (setq org-export-with-section-numbers nil)

  (defvar this-date-format "%b %d, %Y")
  (defun blog/html-postamble (plist)
      "PLIST."
      (concat (format
               (with-temp-buffer
                 (insert-file-contents (concat blog-templates "postamble.html")) (buffer-string))
               (format-time-string this-date-format (plist-get plist :time)) (plist-get plist :creator))))

    (defun blog/html-preamble (plist)
    "PLIST: An entry."
    (if (org-export-get-date plist this-date-format)
        (plist-put plist
                   :subtitle (format "Published on %s by %s."
                                     (org-export-get-date plist this-date-format)
                                     (car (plist-get plist :author)))))
    ;; Preamble
    (with-temp-buffer
      (insert-file-contents (concat blog-templates "preamble.html")) (buffer-string)))

  (defun blog/html-index-preamble (plist)
    "PLIST: An entry."
    (if (org-export-get-date plist this-date-format)
        (plist-put plist
                   :subtitle (format "Published on %s by %s."
                                     (org-export-get-date plist this-date-format)
                                     (car (plist-get plist :author)))))
    ;; Preamble
    (with-temp-buffer
      (insert-file-contents (concat blog-templates "index-preamble.html")) (buffer-string)))

  (defun me/org-sitemap-format-entry (entry style project)
    "Format posts with author and published data in the index page.

ENTRY: file-name
STYLE:
PROJECT: `posts in this case."
    (cond ((not (directory-name-p entry))
           (format "*[[file:%s][%s]]*
                 #+HTML: <p class='pubdate'>by %s on %s.</p>"
                   entry
                   (org-publish-find-title entry project)
                   (car (org-publish-find-property entry :author project))
                   (format-time-string this-date-format
                                       (org-publish-find-date entry project))))
          ((eq style 'tree) (file-name-nondirectory (directory-file-name entry)))
          (t entry)))

  (setq me/music-preamble-path "./.music-preamble.org")
  (defun me/org-sitemap-music-function (title list)
    "Takes path of other file to include into index.org before an index"
    "Generate the sitemap (Blog Music Page)"
    (concat "#+TITLE: " title "\n"
            "#+INCLUDE:" me/music-preamble-path "\n"
            (string-join (mapcar #'car (cdr list)) "\n\n"))

    )

(setq index-preamble "<section>
                 <div> <h3> Segmentation Fail. Horhik's blog </h3></div>
      <div><ul>
        <li><a href='./posts/index.html'>Posts</a></li>
        <li><a href='./portfolio/index.html'>Portfolio</a></li>
        <li><a href='./about/index.html'>About</a></li>
        <li><a href='./donate/index.html'>Donate</a></li>
        <li><a href='./projects/index.html'>Projects</a></li>
       </ul></div>
                </section>")
(setq inner-preamble "<header>
                 <div> <h3> <a href='../index.html'>Horhik's blog </a></h3></div>
      <div><ul>
        <li><a href='../posts/index.html'>Posts</a></li>
        <li><a href='../portfolio/index.html'>Portfolio</a></li>
        <li><a href='../about/index.html'>About</a></li>
        <li><a href='../donate/index.html'>Donate</a></li>
        <li><a href='../projects/index.html'>Projects</a></li>
       </ul></div>
                </header>")

(setq site-postamble "<footer><p>
               <b> This site is made by Horhik and all contens are under CC I forgot full license name </b>
             </p></footer>")
(setq org-html-preamble-format `(("en", inner-preamble)))
(setq org-html-postamble-format `(("en", site-postamble)))

    (require 'ox-publish)


    (setq org-publish-project-alist
          `(
            ("blogposts"
             :base-directory ,(concat blog-content-path "posts")
             :base-extension "org"
             :publishing-directory ,(concat blog-static-path "posts")
             :publishing-function org-html-publish-to-html
             :recursive t
             :headline-levels 8
             :html-preamble blog/html-preamble
             :html-postamble blog/html-postamble
             :auto-sitemap t
             :sitemap-format-entry me/org-sitemap-format-entry
             :sitemap-filename "index.org"
             :sitemap-title "Blog Index"
             :with-tags t
             :with-toc t
             :section-numbers: nil
             :table-of-contents t
             :html-head-include-default-style nil
             )
            ("portfolio"
             :base-directory ,(concat blog-content-path "portfolio")
             :base-extension "org"
             :publishing-directory ,(concat blog-static-path "portfolio")
             :publishing-function org-html-publish-to-html
             :recursive t
             :headline-levels 8
             :html-preamble blog/html-preamble
             :html-postamble blog/html-postamble
             :auto-sitemap t
             :sitemap-format-entry me/org-sitemap-format-entry
             :sitemap-filename "index.org"
             :sitemap-title "Portfolio"
             :sitemap-style list
             :with-tags t
             :with-toc t
             :section-numbers: nil
             :table-of-contents nil
             :html-head-include-default-style nil
             )
            ("about"
             :base-directory ,(concat blog-content-path  "about")
             :base-extension "org"
             :publishing-directory ,(concat blog-static-path  "about")
             :publishing-function org-html-publish-to-html
             :recursive t
             :headline-levels 8
             :html-preamble blog/html-preamble
             :html-postamble blog/html-postamble
             :validation-link nil

             :section-numbers: nil
             :table-of-contents nil
             :with-toc nil
             :html-head-include-default-style nil
             )
            ("donate"
             :base-directory ,(concat blog-content-path  "donate")
             :base-extension "org"
             :publishing-directory ,(concat blog-static-path  "donate")
             :publishing-function org-html-publish-to-html
             :recursive t
             :headline-levels 8
             :html-preamble blog/html-preamble
             :html-postamble blog/html-postamble
             :validation-link nil
             :with-toc nil
             :table-of-contents nil
             :html-head-include-default-style nil
             :section-numbers: nil
             )
            ("projects"
             :base-directory ,(concat blog-content-path  "projects")
             :base-extension "org"
             :publishing-directory ,(concat blog-static-path  "projects")
             :publishing-function org-html-publish-to-html
             :recursive t
             :headline-levels 8
             :html-preamble blog/html-preamble
             :html-postamble blog/html-postamble
             :validation-link nil
             :table-of-contents nil
             :html-head-include-default-style nil
             :section-numbers: nil
             )


            ("blogstatic"
             :base-directory "~/Blog/pages/"
             :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
             :publishing-directory ,(concat  blog-static-path "")
             :recursive t
             :publishing-function org-publish-attachment
             :section-numbers: nil
             )
            ("index"
             :base-directory ,(concat blog-content-path "")
             :base-extension "org"
             :publishing-directory ,(concat blog-static-path "")
             :publishing-function org-html-publish-to-html
             :site-toc nil

             :section-numbers: nil
             :table-of-contents: nil
             :auto-sitemap: t
             :sitemap-format-entry me/org-sitemap-format-entry
             :headline-levels 8
             :html-preamble blog/html-index-preamble
             :html-postamble blog/html-postamble
             )
            ("music"
               :base-directory ,(concat blog-content-path "music")
               :base-extension "org"
               :publishing-directory ,(concat blog-static-path "music")
               :publishing-function org-html-publish-to-html
               :recursive t
               :headline-levels 8
               :html-preamble blog/html-preamble
               :html-postamble blog/html-postamble
               :auto-sitemap t
               :sitemap-format-entry me/org-sitemap-format-entry
               :sitemap-filename "index.org"
               :sitemap-function me/org-sitemap-music-function
               :sitemap-title "Music"
               :sitemap-style list
               :with-tags t
               :with-toc t
               :section-numbers: nil
               :table-of-contents nil
               :with-toc nil
               :html-head-include-default-style nil
               )
            ("Blog" :components ("blogposts" "blogstatic"   "about"  "index" "donate" "projects" "portfolio"))

            ("kb"
             :base-directory ,(concat kb-content-path  "")
             :base-extension "org"
             :publishing-directory ,(concat kb-static-path  "")
             :publishing-function org-html-publish-to-html
             :recursive t
             :headline-levels 8
             :html-preamble blog/html-preamble
             :html-postamble blog/html-postamble
             :validation-link nil
             :table-of-contents nil
             :html-head-include-default-style nil
             )

            ("kb-static"
             :base-directory "~/Notes/pages/"
             :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
             :publishing-directory "~/Notes/html/"
             :recursive t
             :publishing-function org-publish-attachment
             )
            ("KB" :components ("kb" "kb-static"))
  ;; ("daily"
  ;;            :base-directory ,(concat daily-content-path  "")
  ;;            :base-extension "org"
  ;;            :publishing-directory ,(concat daily-static-path  "")
  ;;            :publishing-function org-html-publish-to-html
  ;;            :recursive t
  ;;            :headline-levels 8
  ;;            :html-preamble blog/html-preamble
  ;;            :html-postamble blog/html-postamble
  ;;            :validation-link nil
  ;;            :table-of-contents nil
  ;;            :html-head-include-default-style nil
  ;;            )

            ("daily-static"
             :base-directory "~/Notes/journals/"
             :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
             :publishing-directory "~/Notes/html/daily/"
             :recursive t
             :publishing-function org-publish-attachment
             )
            ("DAILY" :components ("daily" "daily-static"))

            )
          )

  (defun roam-sitemap (title list)
    (concat "#+OPTIONS: ^:nil author:nil html-postamble:nil\n"
            "#+SETUPFILE: ./simple_inline.theme\n"
            "#+TITLE: " title "\n\n"
            (org-list-to-org list) "\nfile:sitemap.svg"))

  (setq my-publish-time 0)   ; see the next section for context
  (defun roam-publication-wrapper (plist filename pubdir)
    (org-roam-graph)
    (org-html-publish-to-html plist filename pubdir)
    (setq my-publish-time (cadr (current-time))))

  (add-to-list 'org-publish-project-alist
    '("diary"
       :base-directory "~/Notes/journals"
       :auto-sitemap t
       :sitemap-title "Diary"
       :publishing-directory "~/Notes/html/journals"
        :validation-link nil
        :with-toc nil
        :table-of-contents nil
        :html-head-include-default-style nil
       :style "<link rel=\"stylesheet\" href=\"/home/horhik/Blog/assets/site.css\" type=\"text/css\">"))
