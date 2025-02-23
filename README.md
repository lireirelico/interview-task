# Interview Task

Это базовый Rails-проект, демонстрирующий создание пользователя с использованием ActiveInteraction.

## Структура проекта

- **app/**
    - **controllers/**
        - `users_controller.rb` – контроллер для создания пользователей.
    - **interactions/**
        - **users/**
            - `create.rb` – класс взаимодействия (interaction) для создания пользователя.
    - **models/**
        - `user.rb` – модель пользователя.
        - `interest.rb` – модель интересов.
        - `skill.rb` – модель навыков.
        - `user_interest.rb` – join-модель для связи пользователей и интересов.
        - `user_skill.rb` – join-модель для связи пользователей и навыков.

- **config/**
    - `routes.rb` – маршруты приложения.

- **db/**
    - **migrate/** – миграции базы данных.

- **spec/**
    - **interactions/**
        - **users/**
            - `create_spec.rb` – тесты для класса `Users::Create`.
    - **requests/** (или **controllers/**)
        - `users_spec.rb` – тесты для контроллера `UsersController` (API-тесты).
    - `rails_helper.rb` – конфигурация RSpec.

- **.gitlab-ci.yml** – конфигурация GitLab CI для запуска тестов.

- **.rubocop.yml** – конфигурация RuboCop для проверки стиля кода.

- **Gemfile** – файл с зависимостями проекта.