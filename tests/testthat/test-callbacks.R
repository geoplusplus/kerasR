library(kerasR)

context("Testing callbacks")

check_keras_available <- function() {
  if (!keras_available(silent = TRUE)) {
    skip("Keras is not available on this system.")
  }
}

test_that("callbacks", {
  skip_on_cran()
  check_keras_available()

  X_train <- matrix(rnorm(100 * 10), nrow = 100)
  Y_train <- to_categorical(matrix(sample(0:2, 100, TRUE), ncol = 1), 3)

  mod <- Sequential()
  mod$add(Dense(units = 50, input_shape = dim(X_train)[2]))
  mod$add(Activation("relu"))
  mod$add(Dense(units = 3))
  mod$add(Activation("softmax"))
  keras_compile(mod,  loss = 'categorical_crossentropy', optimizer = RMSprop())

  callbacks <- list(CSVLogger(tempfile()),
                    EarlyStopping(),
                    ReduceLROnPlateau(),
                    TensorBoard(tempfile()))

  keras_fit(mod, X_train, Y_train, batch_size = 32, epochs = 5,
            verbose = 0, callbacks = callbacks, validation_split = 0.2)

  ModelCheckpoint(filepath = tempdir())

  testthat::expect_false(mod$stateful)
})
