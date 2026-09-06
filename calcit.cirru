
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --full` first. Manual edits must follow format and schema conventions, then run `calcit edit format`.") (:package |app)
  :entries $ {}
    :default $ {} (:description |) (:init-fn 'app.main/main!) (:mode :native) (:reload-fn 'app.main/reload!)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |respo-markdown.calcit/ |reel.calcit/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-bullet $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-bullet (text color)
              <> text $ {} (:white-space :nowrap) (:font-size 26) (:writing-mode :vertical-lr) (:color color)
          :examples $ []
          :schema $ :: 'Dynamic
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-container (reel)
              let
                  store $ :store reel
                  states $ :states store
                  cursor $ or (:cursor states) ([])
                  state $ or (:data states)
                    {} $ :content |
                  progress $ :progress store
                div
                  {} $ :style
                    merge ui/global ui/fullscreen ui/column $ {} (:color :white) (:user-select :none) (:overflow :hidden)
                  div
                    {} $ :style
                      merge ui/fullscreen ui/center $ {} (:position :absolute) (:z-index -10)
                    create-element :video $ {}
                      :style $ {} (:width |100%)
                      :src |/videos/diandian.mov
                      :autoplay true
                      :muted true
                      :loop true
                  ; div
                    {} $ :style
                      merge ui/row-parted $ {} (:padding "|16px 24px")
                    <> "|> 喵喵喵喵喵喵" $ {} (:font-size 24)
                    span $ {} (:inner-text "|全屏")
                      :on-click $ fn (e d!) (js/document.body.requestFullscreen)
                  div
                    {} $ :style ui/expand
                    list-> ({})
                      -> (:bullets store)
                        ; filter $ fn (b)
                          let
                              p $ :progress b
                            and (> p progress)
                              < p $ + progress display-duration
                        wo-log
                        map-indexed $ fn (idx b)
                          let
                              dx $ ->
                                - (:progress b) progress
                                / display-duration
                                * js/window.innerWidth
                                negate
                                + $ * 0.25 js/window.innerWidth
                            [] idx $ div
                              {} $ :style
                                {} (:position :absolute)
                                  :top $ -> js/window.innerHeight (+ 400) (- dx)
                                  :right $ -> js/window.innerWidth (- 40)
                                    * $ :rand b
                                    + 40
                              comp-bullet (:content b) (:color b)
                  ; comp-progress $ :progress store
                  ; memof-call comp-footer
                  when dev? $ comp-reel (>> states :reel) reel ({})
          :examples $ []
          :schema $ :: 'Dynamic
        'comp-footer $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-footer () $ div
              {} $ :style
                merge ui/row-parted $ {} (:padding "|8px 16px")
              div
                {} $ :style (merge ui/row-middle)
                span $ {} (:inner-text "|开始/暂停")
                  :on-click $ fn (e d!) (d! :toggle nil)
                =< 8 nil
                div
                  {}
                    :style $ {} (:width 200) (:height 32) (:background-color :white) (:padding "|0 8px") (:border-radius |4px)
                    :value |
                    :on-click $ fn (e d!)
                      let
                          reply $ js/prompt "|弹幕内容"
                        reset-timer!
                        d! :bullet reply
                  <> "|发弹幕" $ {} (:color |#aaa)
              span $ {} (:inner-text "|重新开始")
                :on-click $ fn (e d!) (d! :restart nil)
          :examples $ []
          :schema $ :: 'Dynamic
        'comp-progress $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-progress (progress)
              let
                  ratio $ / progress video-length
                div
                  {} $ :style
                    {} $ :padding "|0px 8px"
                  div
                    {} $ :style
                      {} (:height 12)
                        :border-top $ str "|1px solid " (hsl 0 0 50)
                    div $ {}
                      :style $ {} (:height 16)
                        :border-right $ str "|8px solid " (hsl 0 0 90 0.7)
                        :bottom 8
                        :position :relative
                        :width $ str (* ratio 100) |%
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.container $ :require (respo-ui.core :as ui)
            respo-ui.core :refer $ hsl
            respo.core :refer $ defcomp defeffect <> >> div button textarea span input list-> create-element
            respo.comp.space :refer $ =<
            reel.comp.reel :refer $ comp-reel
            respo-md.comp.md :refer $ comp-md
            app.config :refer $ dev? video-length display-duration
            app.timer :refer $ reset-timer!
            memof.alias :refer $ memof-call
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def dev? $ = |dev (get-env |mode |release)
          :examples $ []
          :schema $ :: 'Dynamic
        'display-duration $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def display-duration $ * 1000 20
          :examples $ []
          :schema $ :: 'Dynamic
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def site $ {} (:storage-key |bullet-train)
          :examples $ []
          :schema $ :: 'Dynamic
        'video-length $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def video-length $ * 1000 60 4
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote (ns app.config)
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*auto-bullets $ %{} 'CodeEntry (:doc |)
          :code $ quote (defatom *auto-bullets nil)
          :examples $ []
          :schema $ :: 'Dynamic
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defatom *reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
          :examples $ []
          :schema $ :: 'Dynamic
        '*ticking $ %{} 'CodeEntry (:doc |)
          :code $ quote (defatom *ticking 0)
          :examples $ []
          :schema $ :: 'Dynamic
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn dispatch! (op op-data)
              when
                and config/dev? $ not= op :states
                println |Dispatch: op
              reset! *reel $ reel-updater updater @*reel op op-data
          :examples $ []
          :schema $ :: 'Dynamic
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn main! ()
              println "|Running mode:" $ if config/dev? |dev |release
              render-app!
              add-watch *reel :changes $ fn (reel prev) (render-app!)
              listen-devtools! |k dispatch!
              .!addEventListener js/window |beforeunload $ fn (event) (persist-storage!)
              repeat! 60 persist-storage!
              ; let
                (raw (.!getItem js/localStorage (:storage-key config/site)))
                when (some? raw)
                  dispatch! :hydrate-storage $ parse-cirru-edn raw
              random-bullets!
              start-tick!
              println "|App started."
          :examples $ []
          :schema $ :: 'Dynamic
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def mount-target $ .!querySelector js/document |.app
          :examples $ []
          :schema $ :: 'Dynamic
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn persist-storage! () $ .!setItem js/localStorage (:storage-key config/site)
              format-cirru-edn $ :store @*reel
          :examples $ []
          :schema $ :: 'Dynamic
        'rand-content! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn rand-content! () $ let
                size $ + 2
                  js/Math.floor $ * 6 (js/Math.random)
              -> (range size)
                .map $ fn (idx)
                  if
                    > (js/Math.random) 0.6
                    , "|呜" "|喵"
                .join-str |
          :examples $ []
          :schema $ :: 'Dynamic
        'random-bullets! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn random-bullets! () $ reset! *auto-bullets
              flipped js/setInterval 400 $ fn ()
                flipped js/setTimeout
                  * 2000 $ js/Math.random
                  fn () $ &doseq
                    _ $ range 8
                    dispatch! :bullet $ {}
                      :content $ rand-content!
                      :rand $ * (js/Math.random) 1
                      :color $ if
                        > (js/Math.random) 0.8
                        hsl
                          * 360 $ js/Math.random
                          , 90 70
                        , :white
          :examples $ []
          :schema $ :: 'Dynamic
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn reload! () $ if (nil? build-errors)
              do (remove-watch *reel :changes) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ refresh-reel @*reel schema/store updater
                js/clearTimeout @*ticking
                js/clearInterval @*auto-bullets
                random-bullets!
                start-tick!
                hud! |ok~ |Ok
              hud! |error build-errors
          :examples $ []
          :schema $ :: 'Dynamic
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn render-app! () $ render! mount-target (comp-container @*reel) dispatch!
          :examples $ []
          :schema $ :: 'Dynamic
        'repeat! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn repeat! (duration cb)
              js/setTimeout
                fn () (cb)
                  repeat! (* 1000 duration) cb
                * 1000 duration
          :examples $ []
          :schema $ :: 'Dynamic
        'start-tick! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn start-tick! () $ reset! *ticking
              timeout-call 20 $ fn ()
                let
                    d $ delta-time!
                    reel-map $ unsafe-coerce @*reel 'Map
                    store-map $ unsafe-coerce (&map:get reel-map :store) 'Map
                  if (&map:get store-map :playing?) (dispatch! :tick d)
                start-tick!
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.main $ :require
            respo.core :refer $ render! clear-cache!
            respo-ui.core :refer $ hsl
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :as schema
            reel.util :refer $ listen-devtools!
            reel.core :refer $ reel-updater refresh-reel
            reel.schema :as reel-schema
            app.config :as config
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
            app.timer :refer $ delta-time!
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'bullet $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def bullet $ {} (:progress nil) (:content |) (:rand 1)
          :examples $ []
          :schema $ :: 'Dynamic
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def store $ {}
              :states $ {}
                :cursor $ []
              :progress 0
              :playing? true
              :bullets $ do bullet ([])
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote (ns app.schema)
    'app.timer $ %{} 'FileEntry
      :defs $ {}
        '*tracked-time $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defatom *tracked-time $ js/Date.now
          :examples $ []
          :schema $ :: 'Dynamic
        'delta-time! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn delta-time! () $ let
                now $ js/Date.now
                delta $ - now @*tracked-time
              reset! *tracked-time now
              , delta
          :examples $ []
          :schema $ :: 'Dynamic
        'reset-timer! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn reset-timer! () $ reset! *tracked-time (js/Date.now)
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote (ns app.timer)
    'app.updater $ %{} 'FileEntry
      :defs $ {}
        'updater $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn updater (store op data op-id op-time)
              case-default op
                do (println "|unknown op:" op) store
                :states $ update-states store data
                :hydrate-storage data
                :tick $ let
                    n $ wo-log
                      + (:progress store) data
                  if (>= n config/video-length) (assoc store :progress config/video-length :playing? false) (assoc store :progress n)
                :toggle $ update store :playing? not
                :restart $ assoc store :progress 0 :playing? true
                :bullet $ update store :bullets
                  fn (xs0)
                    let
                        xs $ if
                          > (count xs0) 800
                          slice xs0 600
                          , xs0
                      conj xs $ merge schema/bullet data
                        {} $ :progress (:progress store)
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.updater $ :require
            respo.cursor :refer $ update-states
            app.schema :as schema
            app.config :as config
