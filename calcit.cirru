
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :native) (:reload-fn 'app.main/reload!)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |memof/ |respo-ui.calcit/ |respo-markdown.calcit/ |reel.calcit/
      :type-slots $ {} $ :dispatch-op |app.schema/Op
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-bullet $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-bullet (text color)
            <> text $ {} (:white-space :nowrap) (:font-size 26) (:writing-mode :vertical-lr) (:color color)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'String 'String
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel)
            let
                store $ decode-map-as (&map:get reel :store) app.schema/Store
                states store.:states
                progress store.:progress
                bullets store.:bullets
                window-width $ viewport-width
                window-height $ viewport-height
              div
                {} $ :style $ -> (merge ui/global ui/fullscreen ui/column) (assoc :color :white) (assoc :user-select :none) (assoc :overflow :hidden)
                div
                  {} $ :style $ merge ui/fullscreen ui/center
                    {} (:position :absolute) (:z-index -10)
                  create-element :video $ unsafe-coerce
                    {}
                      :style $ {} $ :width |100%
                      :src |/videos/diandian.mov
                      :autoplay true
                      :muted true
                      :loop true
                    , 'respo.schema/DomProps
                div
                  {} $ :style ui/expand
                  list-> ({})
                    -> bullets (wo-log)
                      map-indexed $ fn (idx bullet)
                        let
                            bullet-progress bullet.:progress
                            bullet-rand bullet.:rand
                            dx $ -> (- bullet-progress progress) (/ display-duration) (* window-width) negate $ + (* 0.25 window-width)
                          [] idx $ div
                            {} $ :style $ {} (:position :absolute)
                              :top $ -> window-height (+ 400) (- dx)
                              :right $ -> window-width (- 40) (* bullet-rand) (+ 40)
                            comp-bullet bullet.:content bullet.:color
                when dev? $ comp-reel (>> states :reel) reel $ {}
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'app.schema/Reel
            :features $ #{} :js-ffi
        'comp-footer $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-footer ()
            div
              {} $ :style $ merge ui/row-parted
                {} $ :padding "|8px 16px"
              div
                {} $ :style $ merge ui/row-middle
                span $ {} (:inner-text "|开始/暂停")
                  :on-click $ fn (e d!)
                    d! $ Op :toggle
                =< 8 &unit
                div
                  {}
                    :style $ {} (:width 200) (:height 32) (:background-color :white) (:padding "|0 8px") (:border-radius |4px)
                    :value |
                    :on-click $ fn (e d!)
                      match (prompt-text "|弹幕内容")
                        (:some content)
                          do (reset-timer!)
                            d! $ Op :bullet content (random) |white
                        (:none) &unit
                  <> "|发弹幕" $ {} $ :color |#aaa
              span $ {} (:inner-text "|重新开始")
                :on-click $ fn (e d!)
                  d! $ Op :restart
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ []
        'comp-progress $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-progress (progress)
            let
                ratio $ / progress video-length
              div
                {} $ :style $ {} (:padding "|0px 8px")
                div
                  {} $ :style $ {} (:height 12)
                    :border-top $ str "|1px solid " $ hsl 0 0 50
                  div $ {} $ :style
                    {} (:height 16)
                      :border-right $ str "|8px solid " $ hsl 0 0 90 (%some 0.7)
                      :bottom 8
                      :position :relative
                      :width $ str (* ratio 100) |%
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'Number
        'prompt-text $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn prompt-text (message)
            let
                raw $ js/prompt message
              if (js-present? raw)
                %some $ unsafe-coerce raw 'String
                %none
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'String
            :features $ #{} :js-ffi
            :return $ :: 'Option 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require ([] respo-ui.core :as ui)
            [] respo-ui.core :refer $ [] hsl
            [] respo.core :refer $ [] defcomp defeffect <> >> div button textarea span input list-> create-element
            [] respo.comp.space :refer $ [] =<
            [] reel.comp.reel :refer $ [] comp-reel
            [] respo-md.comp.md :refer $ [] comp-md
            [] app.config :refer $ [] dev? video-length display-duration
            [] app.timer :refer $ [] reset-timer!
            [] memof.alias :refer $ [] memof-call
            [] app.schema :refer $ [] Op
            [] js-ffi.browser :refer $ [] viewport-width viewport-height random
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $ option:unwrap-or (get-env |mode) |release
          :examples $ []
          :schema $ :: 'Bool
        'display-duration $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def display-duration (* 1000 20)
          :examples $ []
          :schema $ :: 'Number
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} $ :storage-key |bullet-train
          :examples $ []
          :schema $ :: 'Map 'Tag 'String
        'video-length $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def video-length (* 1000 60 4)
          :examples $ []
          :schema $ :: 'Number
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*auto-bullets $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *auto-bullets 0
          :examples $ []
          :schema $ :: 'Ref 'Number
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *reel
            -> reel-schema/reel (assoc :base app.schema/store) (assoc :store app.schema/store)
          :examples $ []
          :schema $ :: 'Ref 'app.schema/Reel
        '*ticking $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *ticking 0
          :examples $ []
          :schema $ :: 'Ref 'Number
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            when config/dev? $ println |Dispatch: op
            reset! *reel $ assert-type (reel-updater updater @*reel op) 'app.schema/Reel
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Enum
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println "|Running mode:" $ if config/dev? |dev |release
            render-app!
            add-watch *reel :changes $ fn (reel prev) (render-app!)
            listen-devtools! |k dispatch!
            add-event-listener! |beforeunload $ fn (event) (persist-storage!)
            repeat! 60 persist-storage!
            random-bullets!
            start-tick!
            println "|App started."
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            option:unwrap $ query-selector |.app
          :examples $ []
          :schema $ :: 'js-ffi.browser/DomElementHost
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            storage-set! (config/site :storage-key)
              format-cirru-edn $ decode-map-as (&map:get @*reel :store) app.schema/Store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'rand-content! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn rand-content! ()
            let
                size $ + 2 $ floor
                  * 6 $ random
              -> (range size)
                map $ fn (idx)
                  if
                    > (random) 0.6
                    , "|呜" "|喵"
                join-str |
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ []
        'random-bullets! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn random-bullets! ()
            reset! *auto-bullets $ set-interval!
              fn ()
                set-timeout!
                  fn () $ &doseq
                    _ $ range 8
                    dispatch! $ app.schema/Op :bullet (rand-content!) (random)
                      if
                        > (random) 0.8
                        hsl
                          * 360 $ random
                          , 90 70
                        , |white
                  * 2000 $ random
                , &unit
              , 400
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (remove-watch *reel :changes) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ assert-type (refresh-reel @*reel app.schema/store updater) 'app.schema/Reel
                clear-timeout! @*ticking
                clear-interval! @*auto-bullets
                random-bullets!
                start-tick!
                hud! |ok~ |Ok
              hud! |error build-errors
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render! mount-target (comp-container @*reel) dispatch!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'repeat! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn repeat! (duration callback)
            set-interval! callback $ * 1000 duration
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'Number $ :: 'Fn
              {} (:return 'Unit)
                :args $ []
        'start-tick! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn start-tick! ()
            reset! *ticking $ set-timeout!
              fn ()
                let
                    delta $ delta-time!
                    store $ decode-map-as (&map:get @*reel :store) app.schema/Store
                  when store.:playing? $ dispatch! $ app.schema/Op :tick delta
                start-tick!
              , 20
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            [] respo.core :refer $ [] render! clear-cache!
            [] respo-ui.core :refer $ [] hsl
            [] app.comp.container :refer $ [] comp-container
            [] app.updater :refer $ [] updater
            [] app.schema :as schema
            [] reel.util :refer $ [] listen-devtools!
            [] reel.core :refer $ [] reel-updater refresh-reel
            [] reel.schema :as reel-schema
            [] app.config :as config
            [] |./calcit.build-errors :default build-errors
            [] |bottom-tip :default hud!
            [] app.timer :refer $ [] delta-time!
            [] js-ffi.browser :refer $ [] query-selector add-event-listener! set-interval! set-timeout! clear-timeout! clear-interval! storage-set! random
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'Bullet $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Bullet (:progress 'Number) (:content 'String) (:rand 'Number) (:color 'String)
          :examples $ []
          :schema $ :: 'StructDef
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op
            :states (:: 'List 'Dynamic) 'Dynamic
            :hydrate-storage 'app.schema/Store
            :tick 'Number
            :toggle
            :restart
            :bullet 'String 'Number 'String
            :reel/toggle
            :reel/recall 'Number
            :reel/run
            :reel/step
            :reel/merge
            :reel/reset
            :reel/remove 'Number
          :examples $ []
          :schema $ :: 'EnumDef
        'Reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def Reel &unit
          :examples $ []
          :schema $ :: 'Map 'Tag 'Dynamic
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store
            :states $ :: 'Map 'Tag 'Dynamic
            :progress 'Number
            :playing? 'Bool
            :bullets $ :: 'List 'app.schema/Bullet
          :examples $ []
          :schema $ :: 'StructDef
        'bullet $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def bullet
            Bullet :progress 0 :content | :rand 1 :color |white
          :examples $ []
          :schema $ :: 'app.schema/Bullet
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            Store :states
              {} $ :cursor $ []
              , :progress 0 :playing? true :bullets $ []
          :examples $ []
          :schema $ :: 'app.schema/Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.timer $ %{} 'FileEntry
      :defs $ {}
        '*tracked-time $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *tracked-time (now-ms)
          :examples $ []
          :schema $ :: 'Ref 'Number
        'delta-time! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn delta-time! ()
            let
                now $ now-ms
                delta $ - now @*tracked-time
              reset! *tracked-time now
              , delta
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
        'reset-timer! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reset-timer! ()
            reset! *tracked-time $ now-ms
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.timer
          :require $ [] js-ffi.shared :refer $ [] now-ms
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            match op
              (:states cursor data)
                decode-map-as (update-states store cursor data) app.schema/Store
              (:hydrate-storage data) data
              (:tick data)
                let
                    next-progress $ wo-log $ + store.:progress data
                  if (>= next-progress config/video-length)
                    -> store (assoc :progress config/video-length) (assoc :playing? false)
                    assoc store :progress next-progress
              (:toggle) (update store :playing? not)
              (:restart)
                -> store (assoc :progress 0) (assoc :playing? true)
              (:bullet content rand color)
                let
                    items0 store.:bullets
                    items $ if
                      > (count items0) 800
                      slice items0 600
                      , items0
                  assoc store :bullets $ conj items $ app.schema/Bullet :progress store.:progress :content content :rand rand :color color
              _ $ do (println "|unknown op:" op) store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'app.schema/Store 'Enum 'String 'Number
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require
            [] respo.cursor :refer $ [] update-states
            [] app.schema :as schema
            [] app.config :as config
