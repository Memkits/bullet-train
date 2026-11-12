
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/ |reel.calcit/
      :type-slots $ {} $ :dispatch-op 'app.schema/Op
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-bullet $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-bullet (text color)
            <> text $ {} (:white-space :nowrap) (:font-size 26) (:writing-mode :vertical-lr) (:color color)
          :examples $ []
          :schema $ quote $ Fn String String (-> respo.schema/Component)
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel on-control!)
            let
                store $ :store reel
                states store.:states
                progress store.:progress
                bullets store.:bullets
                window-width $ viewport-width
                window-height $ viewport-height
              div
                {} $ :style $ -> (.merge ui/global ui/fullscreen ui/column) (assoc :color :white) (assoc :user-select :none) (assoc :overflow :hidden)
                div
                  {} $ :style $ .merge ui/fullscreen ui/center
                    {} (:position |absolute) (:z-index |-10)
                  create-element :video $ {}
                    :style $ {} $ :width |100%
                    :src |/videos/diandian.mov
                    :autoplay true
                    :muted true
                    :loop true
                div
                  {} $ :style ui/expand
                  keyed-> ({})
                    -> bullets $ map-indexed $ fn (idx bullet)
                      let
                          bullet-progress bullet.:progress
                          bullet-rand bullet.:rand
                          dx $ -> (- bullet-progress progress) (/ display-duration) (* window-width) negate $ + (* 0.25 window-width)
                        keyed-element idx $ div
                          {} $ :style $ {} (:position :absolute)
                            :top $ -> window-height (+ 400) (- dx)
                            :right $ -> window-width (- 40) (* bullet-rand) (+ 40)
                          comp-bullet bullet.:content bullet.:color
                if dev?
                  Some $ comp-typed-reel (>> states :reel) reel ({}) on-control!
                  , None
          :examples $ []
          :schema $ quote $ Fn (reel.typed/State Op app.schema/Store)
            Fn reel.typed/Control $ -> Unit
            -> respo.schema/Component
            :features :js-ffi
        'comp-footer $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-footer ()
            div
              {} $ :style $ .merge ui/row-parted
                {} $ :padding "|8px 16px"
              div
                {} $ :style ui/row-middle
                span $ {} (:inner-text "|开始/暂停")
                  :on-click $ fn (e d!)
                    d! $ Op :toggle
                space-x 8
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
          :schema $ quote $ Fn (-> respo.schema/Component) (:features :state)
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
                      :border-right $ str "|8px solid " $ hsl 0 0 90 (Some 0.7)
                      :bottom 8
                      :position :relative
                      :width $ str (* ratio 100) |%
          :examples $ []
          :schema $ quote $ Fn Number (-> respo.schema/Component)
        'prompt-text $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn prompt-text (message) (js-ffi.browser/prompt! message)
          :examples $ []
          :schema $ quote $ Fn String
            -> $ Option String
            :features :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require (respo-ui.core :as ui)
            respo-ui.core :refer $ hsl
            respo.core :refer $ defcomp defeffect <> >> div button textarea span input keyed-> keyed-element create-element
            respo.comp.space :refer $ space-x
            app.config :refer $ dev? video-length display-duration
            app.timer :refer $ reset-timer!
            app.schema :refer $ Op
            js-ffi.browser :refer $ viewport-width viewport-height random
            reel.comp.reel :refer $ comp-typed-reel
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $ .unwrap-or (get-env |mode) |release
          :examples $ []
          :schema $ quote Bool
        'display-duration $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def display-duration (* 1000 20)
          :examples $ []
          :schema $ quote Number
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} $ :storage-key |bullet-train
          :examples $ []
          :schema $ quote $ Map Tag String
        'video-length $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def video-length (* 1000 60 4)
          :examples $ []
          :schema $ quote Number
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*auto-bullets $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *auto-bullets 0
          :examples $ []
          :schema $ quote $ Ref Number
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *reel (typed/new-reel app.schema/store)
          :examples $ []
          :schema $ quote $ Ref (typed/State schema/Op schema/Store)
        '*ticking $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *ticking 0
          :examples $ []
          :schema $ quote $ Ref Number
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            when config/dev? $ println |Dispatch: op
            dispatch-resolved! op
            , &unit
          :examples $ []
          :schema $ quote $ Fn schema/Op (-> Unit) (:features :io :state)
        'dispatch-resolved! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch-resolved! (op)
            reset! *reel $ match op
              (reel.typed/Control control) (typed/apply-control updater @*reel control)
              (app.schema/Op action)
                typed/record-op updater @*reel action (generate-id!) (host/now-ms)
            , &unit
          :examples $ []
          :schema $ quote $ Fn schema/ResolvedOp (-> Unit) (:features :js-ffi :state)
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println "|Running mode:" $ if config/dev? |dev |release
            render-app!
            add-watch! *reel :changes $ fn (reel prev) (render-app!)
            listen-devtools! |k on-control!
            add-event-listener! |beforeunload $ fn (event) (persist-storage!)
            repeat! 60 persist-storage!
            random-bullets!
            start-tick!
            println "|App started."
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            .unwrap $ respo.ffi.browser/query-selector |.app
          :examples $ []
          :schema $ quote respo.dom/DomElement
        'on-control! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-control! (control) (dispatch-resolved! control)
          :examples $ []
          :schema $ quote $ Fn typed/Control (-> Unit) (:features :state)
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            storage-set!
              .unwrap $ get config/site :storage-key
              format-cirru-edn $ :store @*reel
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi :state)
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
                join-string |
          :examples $ []
          :schema $ quote $ Fn (-> String)
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
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :state)
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (remove-watch! *reel :changes) (clear-cache!)
                add-watch! *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ typed/refresh updater @*reel app.schema/store
                clear-timeout! @*ticking
                clear-interval! @*auto-bullets
                random-bullets!
                start-tick!
                hud! |ok~ |Ok
              hud! |error build-errors
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render-with! mount-target
              fn () $ comp-container @*reel on-control!
              , dispatch!
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'repeat! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn repeat! (duration callback)
            set-interval! callback $ * 1000 duration
          :examples $ []
          :schema $ quote $ Fn Number
            Fn $ -> Unit
            -> Number
        'start-tick! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn start-tick! ()
            reset! *ticking $ set-timeout!
              fn ()
                let
                    delta $ delta-time!
                    store $ :store @*reel
                  when store.:playing? $ dispatch! $ app.schema/Op :tick delta
                start-tick!
              , 20
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :state)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render-with! clear-cache!
            respo-ui.core :refer $ hsl
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :as schema
            reel.util :refer $ listen-devtools!
            app.config :as config
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
            app.timer :refer $ delta-time!
            js-ffi.browser :refer $ query-selector add-event-listener! set-interval! set-timeout! clear-timeout! clear-interval! storage-set! random
            reel.typed :as typed
            js-ffi.shared :as host
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'Bullet $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Bullet (:progress Number) (:content String) (:rand Number) (:color String)
          :examples $ []
          :schema $ quote StructDef
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op
            :states (List respo.schema/CoordKey) String
            :hydrate-storage app.schema/Store
            :tick Number
            :toggle
            :restart
            :bullet String Number String
          :examples $ []
          :schema $ quote EnumDef
        'ResolvedOp $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion ResolvedOp Op reel.typed/Control
          :examples $ []
          :schema $ quote UnionDef
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store
            :states $ Map Tag Dynamic
            :progress Number
            :playing? Bool
            :bullets $ List app.schema/Bullet
          :examples $ []
          :schema $ quote StructDef
        'bullet $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def bullet
            Bullet :progress 0 :content | :rand 1 :color |white
          :examples $ []
          :schema $ quote Bullet
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            Store :states
              {} $ :cursor $ []
              , :progress 0 :playing? true :bullets $ []
          :examples $ []
          :schema $ quote Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.timer $ %{} 'FileEntry
      :defs $ {}
        '*tracked-time $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *tracked-time (now-ms)
          :examples $ []
          :schema $ quote $ Ref Number
        'delta-time! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn delta-time! ()
            let
                now $ now-ms
                delta $ - now @*tracked-time
              reset! *tracked-time now
              , delta
          :examples $ []
          :schema $ quote $ Fn (-> Number) (:features :state)
        'reset-timer! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reset-timer! ()
            reset! *tracked-time $ now-ms
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :state)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.timer
          :require $ js-ffi.shared :refer $ now-ms
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            match op
              (:states cursor data)
                assoc store :states $ decode-map-as (update-state-tree store.:states cursor data) (Map Tag Dynamic)
              (:hydrate-storage data) data
              (:tick data)
                let
                    next-progress $ + store.:progress data
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
                      > (.len items0) 800
                      slice items0 600
                      , items0
                  assoc store :bullets $ conj items $ app.schema/Bullet :progress store.:progress :content content :rand rand :color color
          :examples $ []
          :schema $ quote $ Fn schema/Store schema/Op String Number (-> schema/Store)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require
            respo.cursor :refer $ update-state-tree
            app.schema :as schema
            app.config :as config
