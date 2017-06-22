Rails.application.config.session_store :cookie_store,
                                       key:          '_budgeting_session',
                                       expire_after: 2.days
