# Step 1: Use the official Python image
FROM python:3.9-slim

# Step 2: Set up environment variables for the application
ENV PYTHONUNBUFFERED 1

# Step 3: Install system dependencies for Selenium (including Chrome and ChromeDriver)
RUN apt-get update \
    && apt-get install -y \
    wget \
    curl \
    unzip \
    libnss3 \
    libgdk-pixbuf2.0-0 \
    libxss1 \
    libappindicator3-1 \
    libasound2 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN curl -sS https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb \
    && apt-get -fy install \
    && rm google-chrome-stable_current_amd64.deb

# Install ChromeDriver (latest version for Chrome 91)
RUN wget -q -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/91.0.4472.124/chromedriver_linux64.zip \
    && unzip /tmp/chromedriver.zip -d /usr/local/bin/ \
    && rm /tmp/chromedriver.zip

# Step 4: Set the working directory inside the container
WORKDIR /app

# Step 5: Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Step 6: Copy the application files into the container
COPY . /app

# Step 7: Expose port 8080 for FastAPI
EXPOSE 8080

# Step 8: Command to run the app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
